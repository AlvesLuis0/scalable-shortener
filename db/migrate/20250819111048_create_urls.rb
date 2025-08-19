class CreateUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :urls do |t|
      t.string :original_url, null: false, limit: Url::MAXIMUM_ORIGINAL_LENGTH
      t.string :short_code, null: false, limit: Url::MAXIMUM_SHORT_CODE_LENGTH
    end

    add_index :urls, :short_code, unique: true
    add_index :urls, :original_url
  end
end
