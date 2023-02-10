require 'faraday'

class MeetingJob
  include Sidekiq::Job

  queue_as :default

  def perform(emp_email, emp_id, room)
    user_details = ""
    if SlackId.where(emp_id: emp_email).empty? == true
      user_details = get_slack_details(emp_email, emp_id)
      user_details["slack_id"] = user_details["id"]
      user_details["emp_name"] = user_details["name"]
    else
      user_details = SlackId.find_by(emp_id: emp_id).attributes
    end
    
    res_final = Faraday.post do |req|
      req.url "https://slack.com/api/chat.postMessage"
      req.headers['Authorization'] = 'Bearer xoxp-4790519192513-4777878816402-4764340226151-8504644c2d45df7cf7307a8bdeaac5f3'
      req.params = {"channel":user_details["slack_id"], "text": "Hi #{user_details["emp_name"]}, Your meeting in room #{room} is scheduled in 15mins from now!"}
    end
  end


  private
    def get_slack_details(emp_email, emp_id)
      #get slack user_details
      res_user = Faraday.get do |req|
          req.url "https://slack.com/api/users.lookupByEmail?email=#{emp_email}"
          req.headers['Authorization'] = 'Bearer xoxp-4790519192513-4777878816402-4764340226151-8504644c2d45df7cf7307a8bdeaac5f3'
      end

      user_details = JSON.parse(res_user.body)["user"]
      
      slack_user = SlackId.new(slack_id: user_details["id"], emp_id: emp_id, emp_name: user_details["name"])
      slack_user.save

      return user_details
    end
end
