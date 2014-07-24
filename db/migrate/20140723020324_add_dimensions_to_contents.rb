class AddDimensionsToContents < ActiveRecord::Migration
  def change
    add_column :contents, :dimensions, :string
    add_column :contents, :height, :string
  end
end
