FactoryBot.define do
  factory :bill do
    ilga_id { Faker::Number.unique.number(5) }
    os_id { "ILB0000#{Faker::Number.unique.number(6)}" }
    title { Faker::Company.catch_phrase }
    summary { Faker::Lorem.paragraph(6) }
    session_number { 99 }
    sponsor_name { Faker::Name.name }
    details_url { Faker::Internet.url }

    transient do
      hearing_date nil
    end

    hearing do
      hearing_date.nil? ? build(:hearing) : build(:hearing, date: hearing_date)
    end

    trait :with_associations do
      with_documents
      with_steps
    end

    trait :with_documents do
      documents { build_list(:document, 1) }
    end

    trait :with_steps do
      actions { "" }
      steps { attributes_for_list(:step, 1) }
    end

    trait :with_step_sequence do
      actors = [
        Step::Actors::LOWER,
        Step::Actors::UPPER
      ]

      steps do
        sequence = actors.sample(1 + rand(2))
        sequence << Step::Actors::GOVERNOR if sequence.count == 2 && rand(2).zero?

        sequence.each_with_object([]) do |actor, memo|
          memo << attributes_for(:step, :introduced, actor: actor)
          break(memo) if rand(2).zero?
          memo << attributes_for(:step, :resolved, actor: actor)
        end
      end
    end

    factory :open_states_bill do
      with_steps

      transient do
        hearing nil
        summary nil
      end

      initialize_with do
        OpenStates::ParseBill::Bill.new(
          ilga_id,
          os_id,
          actions,
          steps,
          title,
          session_number,
          details_url,
          sponsor_name
        )
      end
    end
  end
end
