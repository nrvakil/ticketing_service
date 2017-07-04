#
# Ticket Model
#
# @author [nityamvakil]
#
class Ticket < ActiveRecord::Base
  validates_presence_of :user_id, :subject, :status
  validates :status, inclusion: { in: States.ticket_states, default: States.ticket.raised }

  before_update :validate_status, :update_closed_on

  belongs_to :user
  belongs_to :agent

  scope :raised, -> { where(status: States.ticket.raised) }
  scope :open, -> { where(status: [States.ticket.raised, States.ticket.processing]) }

  private

  def validate_status
    if [States.ticket.resolved, States.ticket.rejected, States.ticket.withdrawn]
       .include?(status_was) && status != States.ticket.raised
      raise Exceptions::TicketClosed, 'Ticket is closed for updates!'
    end
  end

  def update_closed_on
    self.closed_on = Time.now if status == States.ticket.resolved ||
                                 status == States.ticket.withdrawn ||
                                 status == States.ticket.rejected
  end
end
