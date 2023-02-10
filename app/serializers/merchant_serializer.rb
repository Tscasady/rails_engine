class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  def hash_for_one_record
    return { data: {} } if @resource.nil?

    super
  end
end
