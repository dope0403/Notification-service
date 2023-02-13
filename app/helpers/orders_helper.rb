module OrdersHelper
    def send_slack_notif_order(chef_name, order_id, user_details)
        notif = "Hi #{user_details["emp_name"]}, your order with Order-ID: #{order_id} is ready! Thanks to chef #{chef_name}"
        res_final = Faraday.post do |req|
            req.url "https://slack.com/api/chat.postMessage"
            req.headers['Authorization'] = "Bearer #{ENV["SLACK_TOKEN"]}"
            req.params = {"channel":user_details["slack_id"], "text": notif}
        end
    end
end