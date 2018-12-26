require 'shopify_api'
login = 'ef3064b67abaff58e61f944ce5c2cb89'
secret = '96835f1ca08b7c120a6ecd6b32b602cd'
shop = 'iconnects'
shop_url = "https://" + login + ":" + secret + "@" + shop + ".myshopify.com/admin"
ShopifyAPI::Base.site = shop_url
shop = ShopifyAPI::Shop.current

SCHEDULER.every '30s', :first_in => 0 do |job|
  # /admin/orders/count.json
  orderCount = ShopifyAPI::Order.count()
  send_event('shopify', {value: orderCount})
 
end

# https://ef3064b67abaff58e61f944ce5c2cb89:96835f1ca08b7c120a6ecd6b32b602cd@iconnects.myshopify.com/admin/orders.json 