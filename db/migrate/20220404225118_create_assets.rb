class CreateAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets do |t|
      t.references :category, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true
      t.jsonb :extras

      t.timestamps
    end
  end
end
