module Types
  ChamberType = GraphQL::ObjectType.define do
    name "Chamber"
    description "A legislative chamber"
    global_id_field :id
    interfaces [GraphQL::Relay::Node.interface]

    # fields
    field :id, !types.ID, "The graph id"
    field :name, !types.String, "The display name"

    # relationships
    connection :committees, -> { CommitteeType.connection_type } do
      description "All of the chamber's committees"
      resolve -> (chamber, args, ctx) { chamber.committees }
    end
  end
end
