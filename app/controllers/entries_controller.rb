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

  def get_slack_payload
    puts params
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