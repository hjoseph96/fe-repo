class AddAncestryDepthToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :ancestry_depth, :integer
    add_index :categories, :ancestry_depth
  end
end
