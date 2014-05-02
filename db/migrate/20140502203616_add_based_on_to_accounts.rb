class AddBasedOnToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :based_on, :text
  end
end
