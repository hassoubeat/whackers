class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.boolean :is_auth
      t.boolean :is_valid

      t.timestamps
    end
  end
end
