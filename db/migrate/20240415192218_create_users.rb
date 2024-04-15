class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :city
      t.string :avatar
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
