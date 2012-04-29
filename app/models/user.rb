class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :encryptable, :confirmable, :lockable

  # Database authenticatable
  field :email,              :type => String, :null => false, :default => ""
  field :encrypted_password, :type => String, :null => false, :default => ""

  # Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  # Rememberable
  field :remember_created_at, :type => Time

  # Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  # Encryptable
  field :password_salt, :type => String

  # Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  # Lockable
  field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  field :locked_at,       :type => Time

  # Token authenticatable
  field :authentication_token, :type => String

  # Fields
  field :username, type: String

  # Validators
  validates :username, :uniqueness => true, :length => { :minimum => 2 }

  # Make sure a token is created
  before_save :ensure_authentication_token

  # Relations
  references_many :designs, inverse_of: :designer
  references_many :favourited_designs, class_name: 'Design', inverse_of: :favourited_users
  references_many :authored_messages, class_name: 'Message', inverse_of: :author
  references_many :messages, inverse_of: :target
  references_many :invoices, inverse_of: :customer

  def to_param
    username
  end
end
