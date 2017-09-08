module Types
  DocumentType = GraphQL::ObjectType.define do
    name 'Document'
    description "A version of a bill's text"
    global_id_field :id
    interfaces [GraphQL::Relay::Node.interface]

    # fields
    field :id, !types.ID, 'The graph id'
    field :number, !types.String, 'The number of the document, e.g. HB 1234'
    field :fullTextUrl, types.String, 'The URL of the full text page', property: :full_text_url
    field :slipUrl, types.String, 'The URL of the witness slip form', property: :slip_url
    field :slipResultsUrl, types.String, 'The URL of the witness slip submission history', property: :slip_results_url
    field :isAmendment, !types.Boolean, 'Whether or not the document is an amendment', property: :is_amendment

    # relationships
    field :bill, !BillType, 'The parent bill'
  end
end
