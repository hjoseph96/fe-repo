class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.integer :parent_id, foreign_key: true
      t.string :name

      t.timestamps

    end
    add_index :categories, :parent_id
  end
end
