class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :title, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
