#
# Create agents table
#
# @author [nityamvakil]
#
class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name, null: false
      t.string :email, null: false, index: true
      t.boolean :is_admin, default: false
      t.string :password_digest, null: false
      t.string :status, null: false, default: 'registered'

      t.timestamps null: false
    end
  end
end
