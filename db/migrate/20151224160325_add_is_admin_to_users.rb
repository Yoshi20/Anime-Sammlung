class AddIsAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_admin, :boolean
    User.find_or_create_by(username: 'jh', email: 'jh@oxon.ch', encrypted_password: '$2a$10$1SbZr0cpYTmi6hdKx54yseXxD63kJUM0FE0OL/Mu978wwPmuJvt4O').update(is_admin: true)
  end
end
