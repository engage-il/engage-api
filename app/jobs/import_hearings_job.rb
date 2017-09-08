class ImportHearingsJob
  include Worker

  def initialize(scraper = Scraper::HearingsTask.new)
    @scraper = scraper
  end

  def perform(chamber_id)
    chamber = Chamber.find(chamber_id)

    committee_hearings_attrs = @scraper.run(chamber)
    committee_hearings_attrs.each do |attrs|
      # rip out the hearing attrs for now
      hearing_attrs = attrs.delete(:hearing)

      # upsert committee
      committee = Committee.upsert_by!(:external_id, attrs.merge(
        chamber: chamber
      ))

      # upsert hearing
      hearing = Hearing.upsert_by!(:external_id, hearing_attrs.merge(
        committee: committee
      ))

      # enqueue the bills import
      ImportHearingBillsJob.perform_async(hearing.id)
    end
  end
end
