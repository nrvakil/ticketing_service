#
# Agent model
#
# @author [nityamvakil]
#
class Agent < ActiveRecord::Base
  has_secure_password

  validates_presence_of :name, :email, :password_digest
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /@/
  validates :status, inclusion: { in: States.agent_states, default: States.agent.registered }

  before_validation :downcase_email
  before_update :restrict_position

  has_many :tickets

  scope :read, -> { includes(:tickets).select(:id, :name, :email, :status).where(is_admin: false).entries }

  private

  def downcase_email
    email.delete(' ').downcase
  end

  def restrict_position
    raise Exceptions::Unauthorized if changes.include? is_admin
  end
end
