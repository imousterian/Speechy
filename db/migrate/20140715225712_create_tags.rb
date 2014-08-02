class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tagname
      t.integer :user_id

      t.timestamps
    end
    add_index :tags, :user_id
  end


end
