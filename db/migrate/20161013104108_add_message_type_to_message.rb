class AddMessageTypeToMessage < ActiveRecord::Migration[5.0]
  def change
	add_column :messages, :message_type, :string
  end
end
