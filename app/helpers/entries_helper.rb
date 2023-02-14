module EntriesHelper
    def send_slack_notif_entry(user_slack_id, message)
        res_final = Faraday.post do |req|
            req.url "https://slack.com/api/chat.postMessage"
            req.headers['Authorization'] = "Bearer #{ENV["SLACK_TOKEN"]}"
            req.params = {"channel": user_slack_id, "blocks": message}
        end
    end
end
