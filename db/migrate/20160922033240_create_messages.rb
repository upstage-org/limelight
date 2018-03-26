class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :sender
      t.references :stage, foreign_key: true
      t.text :nickname

      t.timestamps
    end
  end
end
