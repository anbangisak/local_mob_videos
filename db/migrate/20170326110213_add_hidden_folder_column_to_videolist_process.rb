class AddHiddenFolderColumnToVideolistProcess < ActiveRecord::Migration
  def change
    add_column :videolist_processes, :hidden, :boolean
  end
end
