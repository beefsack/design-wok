class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields

  field :title, type: String, null: false
  field :body, type: String, null: false

  # Callbacks

  before_validation :ensure_parent_message, :ensure_title

  # Validations

  validates :title, :body, :sender, :receiver, :parent_message, :presence => true

  # Relations

  belongs_to :invoice
  belongs_to :sender, class_name: 'User', inverse_of: :sent_messages
  belongs_to :receiver, class_name: 'User', inverse_of: :received_messages
  belongs_to :parent_message, class_name: 'Message', inverse_of: :thread_messages
  has_many :thread_messages, class_name: 'Message', inverse_of: :parent_message

  private
  # Set the parent message to self if it has not been set yet
  def ensure_parent_message
    self.parent_message = self if self.parent_message.nil?
  end

  # Set the title to the parent message title if it has not been set yet
  def ensure_title
    self.title = self.parent_message.title if self.title.nil?
  end
end
