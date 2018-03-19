class AddAddressToOperators < ActiveRecord::Migration[5.1]
  def change
    add_column :operators, :address, :string
  end
end
