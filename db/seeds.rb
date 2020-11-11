# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

OrderAddress.destroy_all
Address.destroy_all
OrderItem.destroy_all
Order.destroy_all
User.destroy_all
Review.destroy_all
Item.destroy_all
BulkDiscount.destroy_all
Merchant.destroy_all

@megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
@brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
@sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
@ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
@giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
@hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
@user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
@order_1 = @user.orders.create!(status: "packaged")
@order_2 = @user.orders.create!(status: "pending")
@order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
@order_item_2 = @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 5, fulfilled: true)
@order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
@address1 = Address.create(nickname: 'home',
                          address: '123 Dope St',
                          city: 'Awesome Town',
                          state: 'YO',
                          zip: 12345,
                          user_id: @user.id)
OrderAddress.create!(order_id: @order_1.id,
                      address_id: @address1.id)
OrderAddress.create!(order_id: @order_2.id,
                      address_id: @address1.id)
