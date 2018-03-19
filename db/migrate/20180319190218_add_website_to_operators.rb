class AddWebsiteToOperators < ActiveRecord::Migration[5.1]
  def change
    add_column :operators, :website, :string
  end
end
