class AddPasswordDigestToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :password_digest, :string
  end
end
