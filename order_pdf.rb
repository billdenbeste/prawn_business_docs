require 'letterhead_pdf'

class OrderPdf < LetterheadPdf

  def initialize(order)
  	super(top_margin: 30)
    @order = order
    @user = User.find(order.user_id)

    fill_color "000000"

    # all content except footers goes inside this box, which flows across pages
    bounding_box([0, margin_box.height], width: margin_box.width, height: margin_box.height - 30) do

      corporate_name
      doc_title('Product Order')
      order_info(@order)

      @billaddress = Address.where("user_id = ? and kind = ?", @user.id, "billing").first
      billing_address(@billaddress) if @billaddress != nil

      @shipaddress = Address.where("user_id = ? and kind = ?", @user.id, "shipping").first
      shipping_address(@shipaddress) if @shipaddress != nil

      @lineitems = Lineitem.where("lineitems.order_id = ?", @order.id)
      lineitem_table

      move_down 5

      totals
    end

    #next items are positioned absolute and repeat on every page
    number_pages "Page <page> of <total>", at: [0, 20], align: :center
    
    repeat(:all) do
      doc_footer
    end
  end

  #order-specific sections
  def lineitem_table
    table lineitem_rows do |t|
      t.column_widths = [30, 50, 330, 30, 40, 60]
      t.row(0).font_style = :bold
      t.columns(0...1).align = :center
      t.columns(3...5).align = :right
      t.cells.padding = 2
      t.cells.height = 16
      t.header = true
    end
  end

  def lineitem_rows
    [["Item", "Product", "Description", "Qty", "Price", "Extended"]] +
    @lineitems.map.with_index(1) do |lineitem, index|
      product = get_product(lineitem)
      [index, product.name, product.short_desc, lineitem.quantity, number_to_currency(lineitem.unit_price), number_to_currency(lineitem.subtotal)]
    end
  end

  def totals
    bounding_box([0, cursor], width: margin_box.width, height: 100) do
#      stroke_bounds
      move_down 5
      text "<b>Product Total</b> #{number_to_currency(@order.product_amount)}", align: :right
      text "<b>Handling</b> #{number_to_currency(@order.handling_amount)}", align: :right
      text "<b>Shipping</b> #{number_to_currency(@order.shipping_amount)}", align: :right
      text "<b>Insurance</b> #{number_to_currency(@order.insurance_amount)}", align: :right
      text "<b>Total Amount</b> #{number_to_currency( @order.product_amount +
                                                 @order.handling_amount +
                                                 @order.shipping_amount +
                                                 @order.insurance_amount )}", align: :right
    end
  end
end