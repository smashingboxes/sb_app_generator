class Env < Settingslogic
  source "#{Rails.root}/config/env.yml"
  namespace Rails.env
  suppress_errors Rails.env.production?
end