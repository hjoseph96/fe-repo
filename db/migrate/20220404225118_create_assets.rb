class CreateAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets do |t|
      t.references :category, null: false, foreign_key: true
      t.references :author, foreign_key: true
      t.string :title
      t.jsonb :extras
      t.string :extension

      t.timestamps
    end

    add_index :assets, :title
  end
end
