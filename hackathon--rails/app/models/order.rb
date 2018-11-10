class Order < ApplicationRecord
  belongs_to :user, dependent: :destroy
  before_create :set_order_id_key

  private
  def set_order_id_key
    begin
      self.oid = SecureRandom.urlsafe_base64
    end while Order.exists?(oid: self.oid)
  end
end
