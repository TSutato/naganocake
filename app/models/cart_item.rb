class CartItem < ApplicationRecord
  
  belongs_to :customer
  belongs_to :item

  validates :item_id, uniqueness: { scoupe: :customer_id }
  # 1以上10以下
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  def subtotal
    item.add_tax_price * amount
  end
end
