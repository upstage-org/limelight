class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :sender
      t.references :stage, foreign_key: true

      t.timestamps
    end
  end
end
                   