class OrdersController < ApplicationController

  def orderpdf
    @order = Order.find(params[:id])
    pdf = OrderPdf.new(@order)
    send_data pdf.render, filename: "order_#{@order.id}",
                              type: "application/pdf",
                              disposition: "inline"
  end
end
