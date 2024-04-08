class ChangeApprovedColumnTypeInUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :approved_integer, :integer

    User.reset_column_information
    User.find_each do |user|
      user.update(approved_integer: user.approved ? 1 : 0)
    end

    remove_column :users, :approved
    rename_column :users, :approved_integer, :approved
  end

  def down
    change_column :users, :approved, :boolean
  end
end
