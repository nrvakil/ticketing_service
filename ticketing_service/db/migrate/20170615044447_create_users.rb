#
# Create Users
#
# @author [nityamvakil]
#
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: true
      t.string :password_digest, null: false
      t.string :status, null: false, default: 'active'

      t.timestamps null: false
    end
  end
end
