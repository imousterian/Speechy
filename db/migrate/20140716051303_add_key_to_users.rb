class AddKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string
    add_column :users, :access_secret, :string
    add_column :users, :uid, :string
    add_column :users, :dropbox_session, :binary
  end
end
