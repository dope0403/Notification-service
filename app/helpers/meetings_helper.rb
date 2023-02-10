require 'faraday'

module MeetingsHelper
    def get_slack_details(emp_email, emp_id)
        #get slack user_details
        res_user = Faraday.get do |req|
            req.url "https://slack.com/api/users.lookupByEmail?email=#{emp_email}"
            req.headers['Authorization'] = 'Bearer xoxp-4790519192513-4777878816402-4764340226151-8504644c2d45df7cf7307a8bdeaac5f3'
        end

        user_details = JSON.parse(res_user.body)["user"]
        
        slack_user = SlackId.new(slack_id: user_details["id"], emp_id: emp_id)  
        slack_user.save

        return user_details
    end
end
