class User < ActiveRecord::Base
  attr_accessible :name, :role, :email, :password, :password_confirmation
  has_secure_password
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
#  attr_accessor :password
  before_create { generate_token(:auth_token) }
  before_save :encrypt_password

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  # Avatar image
  attr_accessible :image, :image_cache, :remote_image_url, :remove_image,:role
  serialize :crop_params, Hash
  mount_uploader :image, AvatarUploader
  include ImageCrop

  
  # validate :name, :presence => true
  
  ROLES = %w[member admin super]
  
  def admin_or_super?
    admin? || super?
  end
  
  def super?
    role == 'super'
  end
  
  def admin?
    role == 'admin'
  end
  
  def member?
    role == 'member' || role.nil? # Until role is set to :member by default
  end
  
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def is_first_user(user)
    user.id == 1
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  
  
end

