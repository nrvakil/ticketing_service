#
# Spec helpers
#
# @author [nityamvakil]
#
module Helpers
  def time_of_next(day)
    time  = Time.zone.parse(day)
    delta = time > Time.zone.today ? 0 : 7
    time + delta
  end
end
