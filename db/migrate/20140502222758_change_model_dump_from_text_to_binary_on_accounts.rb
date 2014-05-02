class ChangeModelDumpFromTextToBinaryOnAccounts < ActiveRecord::Migration
  def change
    change_table :accounts do |t|
      t.remove :model_dump
      t.binary :model_dump
    end
  end
end
