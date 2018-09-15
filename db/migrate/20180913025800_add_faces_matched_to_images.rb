class AddFacesMatchedToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :faces_matched, :string
    add_column :images, :scene_matched, :string
    add_column :images, :matchid1, :string
    add_column :images, :matchid2, :string
    add_column :images, :matchid3, :string
    add_column :images, :matchid4, :string
  end
end
