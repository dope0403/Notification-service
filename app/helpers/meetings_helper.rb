require 'faraday'

module MeetingsHelper
    def get_slack_details(emp_email, emp_id)
        #get slack user_details
        res_user = Faraday.get do |req|
            req.url "https://slack.com/api/users.lookupByEmail?email=#{emp_email}"
            req.headers['Authorization'] = "Bearer #{ENV["SLACK_TOKEN"]}"
        end
        puts "\n\n" + ENV["SLACK_TOKEN"] + "\n\n"
        user_details = JSON.parse(res_user.body)["user"]
        
        slack_user = SlackId.new(slack_id: user_details["id"], emp_id: emp_id, emp_name: user_details["name"])  
        slack_user.save

        return user_details
    end

    def send_slack_notif(user_details, meeting, type)
        notif = ""
        if type == "cancel"
            notif = "Hi #{user_details["emp_name"]}, Your meeting in room #{meeting["room"]} at #{meeting["time"]} has been cancelled!"
        else
            notif = "Hi #{user_details["emp_name"]}, Your meeting in room #{meeting["room"]} is scheduled in 15mins from now!"
        end

        res_final = Faraday.post do |req|
            req.url "https://slack.com/api/chat.postMessage"
            req.headers['Authorization'] = "Bearer #{ENV["SLACK_TOKEN"]}"
            req.params = {"channel":user_details["slack_id"], "text": notif}
        end
    end
end 
