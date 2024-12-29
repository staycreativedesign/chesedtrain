class DropStageAddStepToEvent < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :stage, :integer
    add_column :events, :step, :integer
  end
end
