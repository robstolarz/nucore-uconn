class RenameUserDeactivatedAtToSuspendedAt < ActiveRecord::Migration

  def change
    rename_column :users, :deactivated_at, :suspended_at
  end

end
