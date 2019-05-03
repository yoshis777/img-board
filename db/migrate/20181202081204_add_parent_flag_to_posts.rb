class AddParentFlagToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :parent_flag, :boolean, default: false
  end
end
