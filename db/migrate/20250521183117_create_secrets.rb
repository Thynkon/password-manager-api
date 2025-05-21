class CreateSecrets < ActiveRecord::Migration[8.0]
  def change
    create_table :secrets do |t|
      t.text :value
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
