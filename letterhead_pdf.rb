class LetterheadPdf < Prawn::Document
  include OrdersHelper
  include MyaccountHelper
  include ActionView::Helpers::NumberHelper

  def text(str, opts={})
    super( str, {inline_format: true}.merge( opts ) )
  end

  def corporate_name
    ht = 35
    loc = cursor
    bounding_box([0, loc], width: margin_box.width, height: ht) do
#     stroke_bounds
      fill_color "ff0000"
      text "<b><i>#{ENV["BUSINESS_NAME"]}</i></b>", size: ht, align: :center, inline_format: true
    end
    move_cursor_to loc - ht
  end

  def doc_title(name)
    ht = 20
    loc = cursor
    bounding_box([0, loc], width: margin_box.width, height: ht) do
#     stroke_bounds
      fill_color "000000"
      text "<b>#{name}</b>", size: ht, align: :center, inline_format: true
    end
    move_cursor_to loc - ht
  end

  def order_info(order)
    ht = 34
    font_size 10
    loc = cursor
    bounding_box([0, loc], width: margin_box.width/3, height: ht) do
#     stroke_bounds
      text "<b>Modelec Order Number:</b> <i>#{@order.id}</i>", inline_format: true, align: :left
      text "<b>Customer P.O. Number:</b> <i>#{@order.customer_po}</i>", inline_format: true, align: :left
    end

    bounding_box([margin_box.width/3, loc], width: margin_box.width/3, height: ht) do
#     stroke_bounds
      text "<b>Order Date:</b> <i>#{@order.printable_commitdate}</i>", inline_format: true, align: :center
    end

    bounding_box([2 * (margin_box.width/3), loc], width: margin_box.width/3, height: ht) do
#     stroke_bounds
      text "<b>Customer:</b> <i>#{@user.name}</i>", inline_format: true, align: :right
      text "<b>email:</b> <i>#{@user.email}</i>", inline_format: true, align: :right
    end
    move_cursor_to loc - ht
  end

  def billing_address(address)
    ht = 80
    loc = cursor
    bounding_box([0, loc], width: margin_box.width/2, height: ht) do
#      stroke_bounds
      move_down 5
      text "<b>Billing Address:</b>", inline_format: true
      text address.full_name
      text address.company_name
      text address.address1
      text address.address2
      text address.city + ', ' + address.state + '  ' + address.zip_code
    end
    move_cursor_to loc
  end

  def shipping_address(address)
    ht = 80
    loc = cursor
    bounding_box([margin_box.width/2, loc], width: margin_box.width/2, height: ht) do
#      stroke_bounds
      move_down 5
      text "<b>Shipping Address:</b>", inline_format: true
      text address.full_name
      text address.company_name
      text address.address1
      text address.address2
      text address.city + ', ' + address.state + '  ' + address.zip_code
    end
    move_cursor_to loc - ht
  end

  def doc_footer
    ht = 20
    bounding_box([0, ht], width: margin_box.width, height: ht) do
#     stroke_bounds
      loc = cursor
      text "#{Time.now.strftime("%b %d, %Y")}"

      move_cursor_to loc
      text "Reprise, Inc.", align: :right
    end
  end
end
