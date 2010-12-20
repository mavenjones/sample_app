class AddEmailNotificationsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_notifications, :boolean, :default => true
  end

  def self.down
    remove_column :users, :email_notifications
  end
end
