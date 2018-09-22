class AddPictureToImagematch < ActiveRecord::Migration[5.2]
  def change
    add_column :imagematches, :picture, :string
  end
end
