module LoginHelper
  def log_in(user_info={})
    uid = user_info[:uid] || '12345'
    email = user_info[:email] || 'foo@gmail.com'
    first_name = user_info[:first_name] ||'Foo'
    latst_name = user_info[:last_name] || 'Bar'
    OmniAuth.config.add_mock(:gplus, {uid:uid,info: {email:email,firt_name:first_name,last_name:latst_name}})
    get "/auth/gplus"
    follow_redirect!
  end
  
  def get_user_for_uid(uid)
    Authentication.find_by(uid:uid).user
  end
end