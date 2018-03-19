class AddInfosToOperators < ActiveRecord::Migration[5.1]
  def change
    add_column :operators, :infos, :text
  end
end
