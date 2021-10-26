class OrderDetail < ApplicationRecord
  belongs_to :item
  belongs_to :order

  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0 }
  validates :amount, presence: true, numericality: {greater_than_or_equal_to: 1 }

  enum making_status: { 着手不可: 0, 製作待ち: 1, 製作中: 2, 製作完了: 3 }

  def subtotal
    price * amount
  end

 def change_order_status
   order_details = self.order.order_details
   if self.making_status == "製作中"
     self.order.update(status: 2)
   elsif order_details.pluck(:making_status).all?{ |making_status| making_status == "製作完了"}
     self.order.update(status: 3)
   end
 end
end
