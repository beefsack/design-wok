class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :name, type: String, required: true

  # Relationships
  has_and_belongs_to_many :designs
end
