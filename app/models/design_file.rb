class DesignFile
  include Mongoid::Document
  include Mongoid::Timestamps

  # Relationships
  has_many :invoices
  belongs_do :design
end
