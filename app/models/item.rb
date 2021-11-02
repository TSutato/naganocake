class Item < ApplicationRecord
  belongs_to :genre
  has_many :cart_items, dependent: :destroy
  has_many :order_details

  validates :name, presence: true
  validates :introduction, presence: true
  # 整数値のみ、最小値0
  validates :price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0 }
  attachment :image


## 消費税を求めるメソッド
 def with_tax_price
  (price * 1.1).floor
 end

  def self.item_search(keyword)
    Item.where('name LIKE ?', "%#{keyword}%")
  end
end
