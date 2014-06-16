class User < ActiveRecord::Base
  has_many :authentications, dependent: :destroy

  has_many :time_entries, dependent: :destroy
end