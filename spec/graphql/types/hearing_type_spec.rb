describe Types::HearingType, :graph_type do
  subject { described_class }

  let(:model) { build(:hearing) }

  it 'exposes its bills' do
    expect(resolve_field(:bills, obj: model)).to eq(model.bills)
  end
end
