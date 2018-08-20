class AddCollectionidToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :collectionid, :string
  end
end
