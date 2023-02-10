class ParamsFilter

  VALID_SEARCH_FIELDS = [:name, :min_price, :max_price]
  
  def initialize(params)
    @params = params
  end

  def filter
    valid_values
  end

  def valid_values
    query = valid_fields
    empty_check(query)
    num_check(query)
    query
  end

  def valid_fields
    query = params.slice(*VALID_SEARCH_FIELDS)
    raise ActionController::ParameterMissing.new('empty') if query.empty?
    raise ActionController::ParameterMissing.new("Can't search for both name and price.") if query.keys.length > 1 && query.include?(:name)
    query
  end

  private

  attr_accessor :params, :query

  def empty_check(query)
    query.each do |_, value|
      raise ActionController::ParameterMissing.new('negative') if value == '' || value.to_i < 0 
    end
  end

  def num_check(query)
    query[:max_price] ||= 9e999
    query[:min_price] ||= 0
    raise ActionController::ParameterMissing.new('Min price is bigger than max price') if query[:min_price].to_f > query[:max_price].to_f
  end
end


