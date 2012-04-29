class Design
  include Mongoid::Document
  include Mongoid::Timestamps

  # Relations
  belongs_to :designer, class_name: 'User', inverse_of: :designs
  has_many :favourited_users, class_name: 'User', inverse_of: :favourited_designs
  has_many :invoices
end
