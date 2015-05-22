class CreateTodoItems < ActiveRecord::Migration

  def up
    create_table :todo_items do |t|
      t.string :name
      t.datetime :due_date
      t.string :status

      t.timestamps null: false
    end
  end

  def down
    drop_table :todo_items
  end

end