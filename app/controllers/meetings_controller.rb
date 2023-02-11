class MeetingsController < ApplicationController
#  before_action :set_meeting, only: %i[ show update destroy ]
  include MeetingsHelper
  # POST /create meeting notif
  def create
    meeting = Meeting.new(meeting_params)

    if meeting.save
      #schedule a reminder job
      time = meeting.time - 60
      MeetingJob.perform_in(time, meeting.employee_id, meeting.employee_email, meeting.room, meeting.time.to_s)

      render json: meeting, status: :created
    else
      render json: meeting.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cancel meeting
  def update
    meeting = Meeting.find_by(meeting_id: params[:id])
    meeting.status = 0

    if meeting.save

      user_details = SlackId.find_by(emp_id: meeting.employee_id).attributes

      #send slack message
      type = "cancel"
      send_slack_notif(user_details, meeting, type)

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
end
