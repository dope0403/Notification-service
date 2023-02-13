module EntriesHelper
    def send_slack_notif_entry(user_slack_id, message)
        res_final = Faraday.post do |req|
            req.url "https://slack.com/api/chat.postMessage"
            req.headers['Authorization'] = 'Bearer xoxp-4790519192513-4777878816402-4764340226151-8504644c2d45df7cf7307a8bdeaac5f3'
            req.params = {"channel": user_slack_id, "text": message}
        end
    end
end
