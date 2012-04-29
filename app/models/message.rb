class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :invoice # Can be related to an invoice, but doesn't have to be
  referenced_in :author, class_name: 'User', inverse_of: :authored_messages
  referenced_in :target, class_name: 'User', inverse_of: :messages
end
