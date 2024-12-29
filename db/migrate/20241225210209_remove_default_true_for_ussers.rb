class RemoveDefaultTrueForUssers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :sms, from: true, to: nil
    change_column_default :users, :tos, from: true, to: nil
    change_column_default :users, :updates, from: true, to: nil
  end
end
