# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :username, null: false
      t.references :user, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }

      t.timestamps null: false

      t.index :username, unique: true
    end
  end
end
