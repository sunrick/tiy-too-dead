class AddColumnTodoLists < ActiveRecord::Migration

  def up
    add_column :todo_lists, :user_id, :integer
  end

  def down
    remove_column :todo_lists, :user_id
  end

end