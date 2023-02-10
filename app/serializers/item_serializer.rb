class ItemSerializer
  include JSONAPI::Serializer

  def hash_for_one_record
    return { data: {} } if @resource.nil?

    super
  end
  
  attributes :name, :description, :unit_price
  attribute :merchant_id
end
