class Env < Settingslogic
  source "#{Rails.root}/config/secrets.yml"
  namespace Rails.env
  suppress_errors Rails.env.production?
end
