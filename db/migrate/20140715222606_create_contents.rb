class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :type
      t.boolean :is_public
      t.string :dblink
      t.integer :user_id

      t.timestamps
    end
  end
end
