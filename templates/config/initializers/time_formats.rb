# Date
# ----------------------------
Date::DATE_FORMATS[:default] = "%b %e, %Y" # Nov 3, 2013
#Date::DATE_FORMATS[:default] = "%Y-%m-%d"  # 2013-11-03
#Date::DATE_FORMATS[:default] = "%B %e, %Y" # November 3, 2013
#Date::DATE_FORMATS[:default] = "%e %b %Y"  # 3 Nov 2013

# Time
# ----------------------------
Time::DATE_FORMATS[:default] = "%b %d, %Y at %I:%M%P"       # Jul 29, 2013 at 11:23am
#Time::DATE_FORMATS[:default] = "%Y-%m-%d %H:%M:%S"         # 2013-11-03 14:22:18
#Time::DATE_FORMATS[:default] = "%B %d, %Y %H:%M"           # November 3, 2013 14:22
#Time::DATE_FORMATS[:default] = "%a, %d %b %Y %H:%M:%S %z"  # Sun, 3 Nov 2013 14:22:18 -0700
#Time::DATE_FORMATS[:default] = "%d %b %H:%M"               # 3 Nov 14:22

# DateTime
# ----------------------------
DateTime::DATE_FORMATS[:default] = Time::DATE_FORMATS[:default]

# I18n.l handle nil
# ----------------------------
module I18n
  class << self
    alias_method :original_localize, :localize
    def localize(object, options = {})
      object.present? ? original_localize(object, options) : ''
    end
  end
end

# Chronic with correct timezone
# ----------------------------
if defined?(Chronic)
  Chronic.time_class = Time.zone
end