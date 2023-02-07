class ItemSerializer
  include JSONAPI::Serializer

  attributes :name, :description, :unit_price
  attribute :merchant_id
end
