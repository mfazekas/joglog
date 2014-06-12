OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :gplus, Rails.application.secrets.gplus_oauth['client_id'], Rails.application.secrets.gplus_oauth['client_secret'], scope: 'userinfo.profile, userinfo.email'
end