class CreateApiHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :api_histories do |t|
      t.string :name, null: false
      t.boolean :is_updated, null: false

      t.timestamps
    end
  end
end
