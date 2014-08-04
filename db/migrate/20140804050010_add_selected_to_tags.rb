class AddSelectedToTags < ActiveRecord::Migration
  def change
    add_column :tags, :selected, :string
  end
end
