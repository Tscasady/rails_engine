require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relations' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'clean_invoices' do
    let!(:merchant) { create(:merchant) }
    let!(:item1) { create(:item, merchant: merchant) }
    let!(:item2) { create(:item, merchant: merchant) }
    let!(:item3) { create(:item, merchant: merchant) }
    let!(:invoice1) { create(:invoice, merchant: merchant) }
    let!(:invoice2) { create(:invoice, merchant: merchant) }
    let!(:invoice_item1) { create(:invoice_item, item: item1, invoice: invoice1) }
    let!(:invoice_item2) { create(:invoice_item, item: item1, invoice: invoice2) }
    let!(:invoice_item3) { create(:invoice_item, item: item2, invoice: invoice2) }
    let!(:invoice_item4) { create(:invoice_item, item: item3, invoice: invoice2) }

    it 'before destroy, it can remove an invoice when it no longer has any items' do
      item1.destroy

      expect { Invoice.find(invoice1.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'before destroy, it will not remove an invoice that still has other items' do
      item1.destroy

      expect(Invoice.find(invoice2.id)).to eq invoice2
      expect(invoice2.items).to eq [item2, item3]
    end
  end
end
