class AddFacematchdetailsToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :facematchdetails, :string
  end
end
