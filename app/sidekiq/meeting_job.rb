require 'faraday'
require 'json'

class MeetingJob
  include Sidekiq::Job
  include MeetingsHelper

  queue_as :default

  def perform(*args)
    user_details = ""
    
    meeting = {}
    meeting["employee_id"] = args[0]
    meeting["employee_email"] = args[1]
    meeting["room"] = args[2]
    meeting["time"] = args[3]

    if SlackId.where(emp_id: meeting["employee_id"]).empty? == true
      user_details = get_slack_details(meeting["employee_email"], meeting["employee_id"])
      user_details["slack_id"] = user_details["id"]
      user_details["emp_name"] = user_details["name"]
    else
      user_details = SlackId.find_by(emp_id: meeting["employee_id"]).attributes
    end
    
    # #send slack notif
    type = "reminder"
    send_slack_notif(user_details, meeting, type)
    
  end
end
