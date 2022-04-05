class CreateAssetCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :asset_collections do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true
    end
  end
end
