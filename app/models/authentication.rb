class Authentication < ActiveRecord::Base
  belongs_to :user

  def self.find_from_authhash(authhash)
    find_by(authhash_to_attributes(authhash))
  end

  def self.create_from_authhash(authhash,user=nil)
    info = authhash['info']
    user ||= User.create!(email: info['email'], first_name: info['first_name'], last_name: info['last_name'])
    user.authentications.create!(self.authhash_to_attributes(authhash))
  end

  private

  def self.authhash_to_attributes(authhash)
    {uid: authhash['uid'],authprovider: authhash['provider']}
  end
end