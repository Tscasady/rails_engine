class Item < ApplicationRecord
  belongs_to :merchant
  before_destroy :clean_invoices

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  

  def clean_invoices
    invoices.each do |invoice|
      invoice.destroy if invoice.items.count == 1
    end
  end

  def self.name_search(search_params)
    where("name ILIKE ?", "%#{search_params[:name]}%").or(where("description ILIKE ?", "%{search_params[:name]}"))
  end

  def self.price_search(search_params)
    where('unit_price >= ?', "#{search_params[:min_price]}").where('unit_price <= ?', "#{search_params[:max_price]}").order(:name)
  end
end
