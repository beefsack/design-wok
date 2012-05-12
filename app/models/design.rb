class Design
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :name, type: String

  # Relations
  belongs_to :designer, class_name: 'User', inverse_of: :designs
  has_many :favourited_users, class_name: 'User', inverse_of: :favourited_designs
  has_many :invoices
  has_many :design_files
  has_and_belongs_to_many :categories
end
