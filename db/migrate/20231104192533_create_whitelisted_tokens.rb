# frozen_string_literal: true

class CreateWhitelistedTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :whitelisted_tokens do |t|
      t.string :jti, null: false
      t.references :user, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.datetime :exp, null: false

      t.timestamps
    end
    add_index :whitelisted_tokens, :jti, unique: true
  end
end
