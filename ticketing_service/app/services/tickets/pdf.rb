require 'prawn'

module Tickets
  #
  # PDF report generation service for tickets
  #
  # @author [nityamvakil]
  #
  class Pdf
    def initialize(params = {})
      @params = params
    end

    attr_reader :filename

    def last_month_report
      @filename = "monthly_report_#{last_month_name}.pdf"
      @tickets = closed_tickets

      pdf = Prawn::Document.new
      pdf.table(headers + data)
      pdf
    end

    private

    def headers
      @tickets.first ? [@tickets.first.keys] : []
    end

    def data
      @tickets.map { |ticket| ticket.values.map(&:to_s) }
    end

    def closed_tickets
      Ticket.joins(:user, :agent)
            .select(selection)
            .where('closed_on between ? and ?',
                   last_month.at_beginning_of_month,
                   last_month.at_end_of_month)
            .entries.as_json(except: :id)
    end

    def last_month_name
      DateTime::MONTHNAMES[Time.now.month - 1]
    end

    def last_month
      Time.zone.now - 1.month
    end

    def selection
      'tickets.id as ID, tickets.status as STATUS,
      tickets.subject as SUBJECT, tickets.closed_on as CLOSED_ON,
      users.name as USER_NAME, users.email as USER_EMAIL,
      agents.name as AGENT_NAME, agents.email as AGENT_EMAIL'
    end
  end
end
