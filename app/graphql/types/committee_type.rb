module Types
  CommitteeType = GraphQL::ObjectType.define do
    name "Committee"
    description "A legislative committee"
    global_id_field :id
    interfaces [GraphQL::Relay::Node.interface]

    # fields
    field :id, !types.ID, "The graph id"
    field :externalId, !types.Int, "The external id", property: :external_id
    field :name, !types.String, "The display name"
  end
end
