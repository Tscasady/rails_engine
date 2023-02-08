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
end
