# ============= AGENTS =============

agents = [
  {
    name: 'Agent 1',
    email: 'agent1@agents.com',
    password: 'agent1',
    status: 'approved'
  },
  {
    name: 'Agent 2',
    email: 'agent2@agents.com',
    password: 'agent2',
    status: 'approved'
  },
  {
    name: 'Agent 3',
    email: 'agent3@agents.com',
    password: 'agent3',
    status: 'approved'
  },
  {
    name: 'Agent 4',
    email: 'agent4@agents.com',
    password: 'agent4'
  },
  {
    name: 'Admin',
    email: 'admin@agents.com',
    password: 'admin',
    status: 'approved',
    is_admin: true
  }
]

agents.each { |agent| Agent.create! agent }

# ============= USERS =============

users = [
  {
    name: 'User 1',
    email: 'user1@users.com',
    password: 'user1'
  },
  {
    name: 'User 2',
    email: 'user2@users.com',
    password: 'user2'
  },
  {
    name: 'User 3',
    email: 'user3@users.com',
    password: 'user3'
  }
]

users.each { |user| User.create! user }

# ============= TICKETS =============

tickets = [
  {
    user_id: User.first.id,
    agent_id: Agent.first.id,
    subject: 'Fridge not working',
    content: 'Please come at the earliest!'
  },
  {
    user_id: User.second.id,
    agent_id: Agent.second.id,
    subject: 'Pipeline break',
    content: 'There is a huge leak. Can someone please come and fix?'
  },
  {
    user_id: User.second.id,
    agent_id: Agent.third.id,
    subject: 'Broken furniture',
    content: 'Lots of broken furniture. Please come and pick it up.'
  },
  {
    user_id: User.last.id,
    agent_id: Agent.first.id,
    subject: 'Order past delivery date!',
    content: 'Can you please check what is holding off the delivery?',
    status: 'resolved',
    closed_on: Time.now - 1.month,
    created_at: Time.now - 2.month
  },
  {
    user_id: User.last.id,
    agent_id: Agent.second.id,
    subject: 'Damaged product',
    content: 'The product I received is damaged. What should I do?',
    status: 'resolved',
    closed_on: Time.now - 1.month,
    created_at: Time.now - 2.month
  },
  {
    user_id: User.first.id,
    agent_id: Agent.last.id,
    subject: 'Refund status',
    content: 'Can you please update on the status of my refund?',
    status: 'resolved',
    closed_on: Time.now - 1.month + 1.day,
    created_at: Time.now - 2.month
  }
]

tickets.each { |ticket| Ticket.create! ticket }
