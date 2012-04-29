class Invoice
  include Mongoid::Document
  include Mongoid::Timestamps

  # Relations
  belongs_to :design
  has_many :design_files
  belongs_to :customer, class_name: 'User', inverse_of: :invoices
end
