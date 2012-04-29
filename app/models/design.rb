class Design
  include Mongoid::Document
  include Mongoid::Timestamps

  # Relations
  referenced_in :designer, class_name: 'User', inverse_of: :designs
  references_many :favourited_users, class_name: 'User', inverse_of: :favourited_designs
  has_many :invoices
end
