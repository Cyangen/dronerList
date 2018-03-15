class AddPecToOperators < ActiveRecord::Migration[5.1]
  def change
    add_column :operators, :pec, :string
  end
end