class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text    :url
      t.string  :short_url
      t.string  :random_hex_string
      t.integer :user_id
    end
  end
end
