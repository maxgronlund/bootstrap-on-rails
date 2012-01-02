class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.string :name
      t.string :role
      t.integer :sign_in_count
      t.string :image
      t.text :crop_params
      t.boolean :grid
      t.string :auth_token
      t.string :password_digest
      t.timestamps
    end
  end
end
