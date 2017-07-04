module Exceptions
  class Unauthorized < StandardError
  end

  class TicketClosed < StandardError
  end

  class MissingAgents < StandardError
  end
end
