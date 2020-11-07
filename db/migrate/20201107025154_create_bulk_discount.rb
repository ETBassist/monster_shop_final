class CreateBulkDiscount < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.float :percent
      t.integer :required_quantity
      t.references :user, foreign_key: true
    end
  end
end
