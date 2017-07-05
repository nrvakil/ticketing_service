#
# User model
#
# @author [nityamvakil]
#
class User < ActiveRecord::Base
  has_secure_password

  validates_presence_of :name, :email, :password_digest
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /@/
  validates :status, inclusion: { in: States.user_states, default: States.user.active }

  before_validation :downcase_email

  has_many :tickets

  scope :read, -> { select(:id, :name, :email, :status).entries }

  def downcase_email
    email.delete(' ').downcase if email
  end
end
