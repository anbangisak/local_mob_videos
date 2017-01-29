class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.string :name
      t.string :chat_data

      t.timestamps null: false
    end
  end
end
