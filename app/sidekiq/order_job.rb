class OrderJob
  include Sidekiq::Job
  include OrdersHelper
  include MeetingsHelper

  queue_as :default

  def perform(*args)
    order = {}
    order["employee_name"] = args[0]
    order["chef_name"] = args[1]
    order["order_id"] = args[2]
    order["employee_id"] = args[3]
    order["employee_email"] = args[4]

    user_details = ""
    if SlackId.where(emp_id: order["employee_id"]).empty? == true
      user_details = get_slack_details(order["employee_email"], order["employee_id"])
      user_details["slack_id"] = user_details["id"]
      user_details["emp_name"] = user_details["name"]
    else
      user_details = SlackId.find_by(emp_id: order["employee_id"]).attributes
    end
    send_slack_notif_order(order["chef_name"], order["order_id"].to_s, user_details)
  end
end
