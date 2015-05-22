class ChangeColumnsTodoItems < ActiveRecord::Migration

  def up
    add_column :todo_items, :todo_list_id, :integer
  end

  def down
    remove_column :todo_lists, :todo_list_id
  end

end