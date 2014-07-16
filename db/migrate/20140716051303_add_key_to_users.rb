class AddKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_key, :string
    add_column :users, :access_secret, :string
    add_column :users, :dropbox_session, :binary
  end
end
