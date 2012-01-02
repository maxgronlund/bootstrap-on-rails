class CreateTextContents < ActiveRecord::Migration
  def change
    create_table :text_contents do |t|
      t.string :title
      t.text :body
      t.string :identity
      t.timestamps
    end
  end
end
