class Address < ApplicationRecord
  belongs_to :customer
  
  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ }
  validates :address, presence: true
  validates :name, presence: true
  
  #配送先
  def full_address
    '〒' + postal_code + ' ' + address + ' ' + name
  end
  
end
