class OrdersController < ApplicationController
  # before_action :set_order, only: %i[ show update destroy ]
  # POST /orders
  def create
    order = Order.new(order_params)

    if order.save
      # create a order completion job
      OrderJob.perform_in(order.duration.seconds, order.employee_name, order.chef_name, order.order_id, order.employee_id, order.employee_email)

      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT 
  def update
    if order.update(order_params)
      render json: order
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:employee_id, :employee_name, :order_id, :duration, :chef_name, :employee_email)
    end
end
