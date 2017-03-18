class CreateVideolistProcesses < ActiveRecord::Migration
  def change
    create_table :videolist_processes do |t|
      t.string :name
      t.string :pid
      t.string :status
      t.datetime :killed_time
      t.string :message
      t.string :details

      t.timestamps null: false
    end
  end
end
