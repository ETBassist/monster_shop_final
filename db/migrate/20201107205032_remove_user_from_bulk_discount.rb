class RemoveUserFromBulkDiscount < ActiveRecord::Migration[5.2]
  def change
    remove_reference :bulk_discounts, :user, index: true, foreign_key: true
    add_reference :bulk_discounts, :merchant, index: true, foreign_key: true
  end
end
