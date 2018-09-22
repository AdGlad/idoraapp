class AddColumnUnqueIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :unique_id, :uuid, default: 'uuid_generate_v4()'
  end
end
