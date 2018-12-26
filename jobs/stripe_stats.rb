#!/usr/bin/env ruby
require 'stripe'

Stripe.api_key = "sk_live_2sUFhkWTuptYXWhwkmKZJaEF"

total_customers = Stripe::Customer.all.count # all customers ever created
number_of_customer_requests = (total_customers.to_f / 100).ceil # number of requests needed to get data on all customers from Stripe
last_customer = nil
active_customers = 0
monthly_revenue = 0

SCHEDULER.every '120m', :first_in => 0 do |job|
	number_of_customer_requests.times do
		Stripe::Customer.all(limit: 100, starting_after: last_customer).each do |customer|
			if customer["subscriptions"]["count"] > 0
				active_customers += 1
				monthly_revenue += customer["subscription"]["plan"]["amount"] / 100
			end
			last_customer = customer # last customer for offset
		end
	end

	data = Array.new
	data.push({label: "Kunder", value: active_customers})
	data.push({label: "Omsætning mdr.", value: monthly_revenue})

	send_event('stripe_stats', {items: data})
end
