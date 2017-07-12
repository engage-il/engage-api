describe ImportBillsJob do
  subject { described_class.new(mock_redis, mock_service) }

  let(:mock_redis) { double('Redis') }
  let(:mock_service) { double('Service') }

  describe '#perform' do
    let(:date) { Time.zone.now }

    before do
      Timecop.freeze(date)

      allow(mock_redis).to receive(:get).with(:import_bills_job_date)
      allow(mock_redis).to receive(:set).with(:import_bills_job_date, anything)
      allow(mock_service).to receive(:fetch_bills).and_return([].lazy)

      allow(ImportBillDetailsJob).to receive(:perform_async)
    end

    after do
      Timecop.return
    end

    it 'fetches bills with the correct fields' do
      subject.perform
      expect(mock_service).to have_received(:fetch_bills) do |args|
        fields = 'id,bill_id,session,title,chamber,versions,sources,sponsors,type'
        expect(args[:fields]).to eq fields
      end
    end

    it 'fetches bills since the last import' do
      allow(mock_redis).to receive(:get).with(:import_bills_job_date).and_return(date)
      subject.perform
      expect(mock_service).to have_received(:fetch_bills) do |args|
        expect(args[:updated_since]).to eq date
      end
    end

    it "sets the last import date when it's done" do
      subject.perform
      expect(mock_redis).to have_received(:set).with(:import_bills_job_date, date)
    end

    context 'when upserting a bill' do
      let(:bill) { create(:bill) }
      let(:attrs) { attributes_for(:bill, external_id: bill.external_id) }

      def perform
        subject.perform
        bill.reload
      end

      def response(attrs = {})
        base_response = {
          'id' => '',
          'title' => '',
          'bill_id' => '',
          'session' => '',
          'sources' => [{
            'url' => "http://ilga.gov/legislation/BillStatus.asp?LegId=#{bill.external_id}"
          }],
          'sponsors' => []
        }

        Array.wrap(base_response.merge(attrs)).lazy
      end

      it "sets the bill's core attributes" do
        allow(mock_service).to receive(:fetch_bills).and_return(response(
          'id' => attrs[:os_id],
          'title' => attrs[:title],
          'bill_id' => attrs[:document_number].gsub(/[A-Z]+/, '\0 '),
          'session' => "#{attrs[:session_number]}th"
        ))

        perform
        expect(bill).to have_attributes(attrs.slice(
          :os_id,
          :title,
          :document_number,
          :session_number
        ))
      end

      it "sets the bill's source-url derived attributes" do
        query = 'DocNum=1234&DocTypeID=SB&GAID=2&SessionID=3'

        allow(mock_service).to receive(:fetch_bills).and_return(response(
          'sources' => [{
            'url' => "http://ilga.gov/legislation/BillStatus.asp?LegId=#{attrs[:external_id]}&#{query}"
          }]
        ))

        perform
        expect(bill).to have_attributes(
          external_id: attrs[:external_id],
          details_url: "http://www.ilga.gov/legislation/billstatus.asp?#{query}",
          full_text_url: "http://www.ilga.gov/legislation/fulltext.asp?#{query}"
        )
      end

      it "sets the bill's primary sponsor name" do
        allow(mock_service).to receive(:fetch_bills).and_return(response(
          'sponsors' => [{
            'type' => 'primary',
            'name' => attrs[:sponsor_name]
          }]
        ))

        perform
        expect(bill).to have_attributes(attrs.slice(
          :sponsor_name
        ))
      end

      it 'imports details for the bill' do
        allow(mock_service).to receive(:fetch_bills).and_return(response)
        perform
        expect(ImportBillDetailsJob).to have_received(:perform_async).exactly(1).times
      end

      it 'creates the bill if it does not exist' do
        attrs2 = attributes_for(:bill)

        allow(mock_service).to receive(:fetch_bills).and_return(response(
          'sources' => [{
            'url' => "http://ilga.gov/legislation/BillStatus.asp?LegId=#{attrs2[:external_id]}"
          }]
        ))

        expect { perform }.to change(Bill, :count).by(1)
      end
    end
  end
end
