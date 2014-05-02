class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.text :uid
      t.text :username
      t.text :name
      t.text :token
      t.text :secret
      t.text :model_dump

      t.timestamps
    end
  end
end
