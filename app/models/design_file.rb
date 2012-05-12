class DesignFile
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  mount_uploader :file, DesignFileUploader
  
  # Relationships
  has_many :invoices
  belongs_to :design
end
