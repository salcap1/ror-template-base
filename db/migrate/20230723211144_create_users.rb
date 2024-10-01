# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :uuid, null: false
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps null: false

      t.index :email, unique: true
    end
  end
end
