require "test_helper"

class MeetingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @meeting = meetings(:one)
  end

  test "should get index" do
    get meetings_url, as: :json
    assert_response :success
  end

  test "should create meeting" do
    assert_difference("Meeting.count") do
      post meetings_url, params: { meeting: { employee_id: @meeting.employee_id, meeting_id: @meeting.meeting_id, room: @meeting.room, status: @meeting.status } }, as: :json
    end

    assert_response :created
  end

  test "should show meeting" do
    get meeting_url(@meeting), as: :json
    assert_response :success
  end

  test "should update meeting" do
    patch meeting_url(@meeting), params: { meeting: { employee_id: @meeting.employee_id, meeting_id: @meeting.meeting_id, room: @meeting.room, status: @meeting.status } }, as: :json
    assert_response :success
  end

  test "should destroy meeting" do
    assert_difference("Meeting.count", -1) do
      delete meeting_url(@meeting), as: :json
    end

    assert_response :no_content
  end
end
