class AddFaceidToIdentities < ActiveRecord::Migration[5.2]
  def change
    add_column :identities, :face_id, :string
    add_column :identities, :external_image_id, :string
  end
end
