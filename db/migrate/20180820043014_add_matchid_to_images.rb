class AddMatchidToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :matchid, :string
  end
end
