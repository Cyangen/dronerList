class AddPhoneToOperators < ActiveRecord::Migration[5.1]
  def change
    add_column :operators, :phone, :string
  end
end
