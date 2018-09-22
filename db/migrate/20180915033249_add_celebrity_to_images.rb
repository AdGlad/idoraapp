class AddCelebrityToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :celebrity, :string
  end
end
