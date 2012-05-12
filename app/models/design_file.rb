class DesignFile
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  
  # Relationships
  has_many :invoices
  belongs_to :design
end
