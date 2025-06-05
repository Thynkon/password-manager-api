class AddSymKeySaltToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :sym_key_salt, :binary
  end
end
