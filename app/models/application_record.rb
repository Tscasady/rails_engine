class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
# TODO: write test and move to model
  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end
end
