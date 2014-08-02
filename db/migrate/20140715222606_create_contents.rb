class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :ctype
      t.boolean :is_public
      t.string :dblink
      t.integer :user_id
      t.text :tag_list

      t.timestamps
    end
    add_index :contents, :user_id
  end

end
