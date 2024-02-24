# frozen_string_literal: true

class CreateRefreshTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :refresh_tokens do |t|
      t.string :access_token_jti, null: false
      t.references :user, null: false, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.datetime :exp, null: false

      t.timestamps
    end
    add_index :refresh_tokens, :access_token_jti, unique: true
  end
end
