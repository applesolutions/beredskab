require 'shopify_api'
login = ''
secret = ''
shop = ''
shop_url = "https://" + login + ":" + secret + "@" + shop + ".myshopify.com/admin"
ShopifyAPI::Base.site = shop_url
shop = ShopifyAPI::Shop.current

SCHEDULER.every '30s', :first_in => 0 do |job|
  # /admin/orders/count.json
  orderCount = ShopifyAPI::Order.count()
  send_event('shopify', {value: orderCount})
 
end