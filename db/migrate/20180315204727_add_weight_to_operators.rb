class AddWeightToOperators < ActiveRecord::Migration[5.1]
  def change
    add_column :operators, :weight, :string
  end
end
