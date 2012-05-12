class Design
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :name, type: String
  field :for_sale_exclusive, type: Boolean, default: false
  field :exclusive_price, type: BigDecimal
  field :for_sale_non_exclusive, type: Boolean, default: false
  field :non_exclusive_price, type: BigDecimal
  field :exclusive_sold, type: Boolean, default: false
  field :non_exclusive_sold, type: Boolean, default: false
  field :deliverables, type: String

  # Relations
  belongs_to :designer, class_name: 'User', inverse_of: :designs
  has_many :favourited_users, class_name: 'User', inverse_of: :favourited_designs
  has_many :invoices
  has_many :design_files
  has_and_belongs_to_many :categories

  # Validations
  validates :name, presence: true
  # Ensure not for sale if sold exclusively
  validates_each :for_sale_exclusive, :for_sale_non_exclusive do |record, attr, value|
    record.errors.add attr, 'not allowed because design has already been sold exclusively' if
      value and record.exclusive_sold
  end
  # Ensure not for sale exclusively if sold non exclusively
  validates_each :for_sale_exclusive do |record, attr, value|
    record.errors.add attr, 'not allowed because design has already been sold non exclusively'
      value and record.non_exclusive_sold  
  end
end
