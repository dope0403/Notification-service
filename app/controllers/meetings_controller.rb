require 'faraday'
require 'json'

class MeetingsController < ApplicationController
#  before_action :set_meeting, only: %i[ show update destroy ]

  # POST /create meeting notif
  def create
    meeting = Meeting.new(meeting_params)

    if meeting.save
      #schedule a reminder job
      time = meeting.time - 15*60
      MeetingJob.perform_in(time, meeting.employee_email, meeting.employee_id, meeting.room)

      render json: meeting, status: :created
    else
      render json: meeting.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cancel meeting
  def update
    meeting = Meeting.find_by(meeting_id: params[:id])
    meeting.status = 0

    userId = SlackId.find_by(emp_id: meeting.employee_id)
    puts userId
    
    user_details = ""
    if meeting.save
      if SlackId.where(emp_id: meeting.employee_id).empty? == true
        user_details = get_slack_details(meeting.employee_email, meeting.employee_id)
        user_details["slack_id"] = user_details["id"]
        user_details["emp_name"] = user_details["name"]
      else
        user_details = SlackId.find_by(emp_id: meeting.employee_id).attributes
      end

      puts user_details
      
      #send slack message
      res_final = Faraday.post do |req|
        req.url "https://slack.com/api/chat.postMessage"
        req.headers['Authorization'] = 'Bearer xoxp-4790519192513-4777878816402-4764340226151-8504644c2d45df7cf7307a8bdeaac5f3'
        req.params = {"channel":user_details["slack_id"], "text": "Hi #{user_details["emp_name"]}, Your meeting in room #{meeting.room} at #{meeting.created_at} has been cancelled!"}
      end


      render json: meeting
    else
      render json: meeting.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      meeting = Meeting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def meeting_params
      params.require(:meeting).permit(:meeting_id, :employee_id, :room, :status, :employee_email, :time)
    end

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
