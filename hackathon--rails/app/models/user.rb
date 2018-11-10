class User < ApplicationRecord
  validates_presence_of :name, :email, :password_digest
  validates_uniqueness_of :email

  has_many :orders

  # encrypt password
  has_secure_password

  def as_json(options={})
    # only return id and name for testing purposes
    super({only: [:id, :name, :is_admin]})
  end

end
