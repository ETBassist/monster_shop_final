class BulkDiscount < ApplicationRecord
  belongs_to :user

  validates_presence_of :percent, :required_quantity
end


# BulkDiscount as of version 2020_11_07_025154
#  create_table "bulk_discounts", force: :cascade do |t|
#    t.float "percent"
#    t.integer "required_quantity"
#    t.bigint "user_id"
#    t.index ["user_id"], name: "index_bulk_discounts_on_user_id"
#  end
