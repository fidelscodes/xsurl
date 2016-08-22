class AddNameColumnToLinks < ActiveRecord::Migration
  def change
    add_column :links, :site_name, :string
  end
end
