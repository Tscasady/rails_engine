class Merchant < ApplicationRecord
  has_many :items

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end
end
