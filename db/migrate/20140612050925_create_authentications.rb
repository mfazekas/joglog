class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :authprovider
      t.string :uid
      t.references :user, index: true
    end
  end
end
