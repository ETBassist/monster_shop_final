class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  # Consider creating OrderAddressesController to handle this?
  def update
    order = Order.find(params[:id])
    order.order_address.update(address_id: params[:addresses])
    flash[:notice] = 'Address Changed'
    redirect_to "/profile/orders/#{order.id}"
  end

  def create
    order = current_user.orders.new
    order.save
      cart.items.each do |item|
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: item.price
          })
      end
    OrderAddress.create(address_id: params[:addresses], 
                        order_id: order.id)
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end
end
