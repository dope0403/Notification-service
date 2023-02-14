class EntriesController < ApplicationController
  # before_action :set_entry, only: %i[ show update destroy ]
  include MeetingsHelper
  include EntriesHelper
  # POST /entries
  def create
    entry = Entry.new(entry_params)

    if entry.save
      user_details = SlackId.find_by(emp_id: params[:employee_id])
      if user_details.nil?
        user_details = get_slack_details(params[:employee_email], params[:employee_id])
        user_details["slack_id"] = user_details["id"]
      end

      send_slack_notif_entry(user_details["slack_id"], params[:message])
      render json: entry, status: :created, location: entry
    else
      render json: entry.errors, status: :unprocessable_entity
    end
  end

  def entry_approval
    entry = Entry.new(employee_id: params[:employee_id], employee_email: params[:employee_email], message: params[:message])
    if entry.save
      user_details = SlackId.find_by(emp_id: params[:employee_id])
      if user_details.nil?
        user_details = get_slack_details(params[:employee_email], params[:employee_id])
        user_details["slack_id"] = user_details["id"]
      end

      message =  [
          {
            "type": "header",
            "text": {
              "type": "plain_text",
              "text": "#{params[:message]}",
              "emoji": true
            }
          },
          {
            "type": "actions",
            "elements": [
              {
                "type": "button",
                "text": {
                  "type": "plain_text",
                  "emoji": true,
                  "text": "Approve"
                },
                "style": "primary",
                "value": "click_me_123"
              },
              {
                "type": "button",
                "text": {
                  "type": "plain_text",
                  "emoji": true,
                  "text": "Reject"
                },
                "style": "danger",
                "value": "click_me_123"
              }
            ]
          }
	    ]
      send_slack_notif_entry(user_details["slack_id"], message)
      render json: entry, status: :created, location: entry
    end
  end

  def get_slack_payload
    payload = params[:payload]
    user_response = JSON.parse(payload)["actions"][0]["text"]["text"]
    # new_payload = JSON.decode(payload)
    # puts new_payload.actions
    # render json: params, status: :ok
  end

  def update
    if entry.update(entry_params)
      render json: entry
    else
      render json: entry.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      entry = Entry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entry_params
      params.require(:entry).permit(:employee_id, :message, :employee_email)
    end
end
