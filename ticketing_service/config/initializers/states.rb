#
# State config container
#
# @author [nityamvakil]
#
class States
  USER_STATE = OpenStruct.new(
    active: 'active',
    banned: 'banned'
  )

  AGENT_STATE = OpenStruct.new(
    registered: 'registered',
    approved: 'approved',
    banned: 'banned'
  )

  TICKET_STATE = OpenStruct.new(
    raised: 'raised',
    processing: 'processing',
    resolved: 'resolved',
    rejected: 'rejected',
    withdrawn: 'withdrawn'
  )

  def self.user
    USER_STATE
  end

  def self.agent
    AGENT_STATE
  end

  def self.ticket
    TICKET_STATE
  end

  def self.user_states
    USER_STATE.to_h.values
  end

  def self.agent_states
    AGENT_STATE.to_h.values
  end

  def self.ticket_states
    TICKET_STATE.to_h.values
  end
end
