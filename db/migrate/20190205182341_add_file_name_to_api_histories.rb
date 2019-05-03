class AddFileNameToApiHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :api_histories, :file_name, :string
  end
end
