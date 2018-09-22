class CreateImageIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :image_identities do |t|
      t.integer :image_id
      t.integer :identity_id
    end
  end
end
