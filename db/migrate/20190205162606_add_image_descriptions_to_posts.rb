class AddImageDescriptionsToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :image_descriptions, :varchar, array: true
  end
end
