#
# Tickets migration
#
# @author [nityamvakil]
#
class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :user_id, null: false, index: true
      t.integer :agent_id, index: true
      t.string :subject, null: false
      t.string :content
      t.datetime :closed_on
      t.string :status, null: false, default: 'raised'

      t.timestamps null: false
    end
  end
end
