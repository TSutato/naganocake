class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details, dependent: :destroy

 validates :total_payment, presence: true, numericality: {greater_than_or_equal_to: 0 }
 validates :shipping_cost, presence: true, numericality: {greater_than_or_equal_to: 0 }
 validates :address, presence: true
 validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ }
 validates :name, presence: true

 enum payment_method: { クレジットカード: 0, 銀行振込: 1 }
 enum status: { 入金待ち: 0, 入金確認: 1, 製作中: 2, 発送準備中: 3, 発送済: 4 }

 def change_making_status
   if self.status == "入金待ち"
     self.order_details.update(making_status: 0)
   elsif self.status == "入金確認"
     self.order_details.update(making_status: 1)
   end
 end

 def get_shipping_info(resource)
   class_name = resource.class.name
   if class_name == 'Customer'
     self.address = resource.address
     self.postal_code = resource.postal_code
     self.name = resource.full_name
   elsif class_name == 'Address'
     self.address = resource.address
     self.postal_code = resource.postal_code
     self.name = resource.name
   end
 end

end
