class RemoveCollectionFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :collection, :string
  end
end
