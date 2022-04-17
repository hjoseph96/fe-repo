class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :asset_depth, default: 1

      t.timestamps

    end
  end
end
