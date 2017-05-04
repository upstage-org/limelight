class FixMediaIdType < ActiveRecord::Migration[5.1]
  # Rails 5.1 changes id column types from int to bigint - Need to adjust
  def change
    change_column :media, :id, :bigint
  end
end
