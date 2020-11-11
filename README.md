![Monsters](https://lh3.googleusercontent.com/proxy/KTsmXfd5QUR4tSTMPYDL-0hDdyVH4-7GzwYoB5wc-Zct8tLMzCZnvGgsIyBUCuvzobMgIEw_kKw3YrIcJZZ_1Q5b5Uk_vcA)  

### Monster Shop
"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will be able to get "shipped" by an admin. Additionally, a merchant can create, edit, and delete discounts for bulk purchases of items they sell, and users can create multiple addresses to which they would like orders shipped.
  
### Setup
  Requires Rails 5.2.4.3 and Ruby 2.5.3; uses a PostgreSQL database. 
  Clone this repo  
  `cd` into the `monster_shop_final` directory  
  Run `bundle` to install necessary gems  
  Run `rails db:{create,migrate,seed}` to create the database  
  Run `rails s` to start the Rails server, navigate your browser to localhost:3000, and enjoy!  

### Schema
![Schema.png](https://user-images.githubusercontent.com/45305677/98761485-60b70c00-238a-11eb-8e18-a181e7b1b5b3.png)
