class CreateTodoLists < ActiveRecord::Migration

  def up
    create_table :todo_lists do |t|
      t.string :name

      t.timestamps null: false
    end
  end

  def down
    drop_table :todo_lists
  end

end