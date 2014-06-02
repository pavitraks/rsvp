require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, event: { address: @event.address, agenda: @event.agenda, created_at: @event.created_at, end_date: @event.end_date, location: @event.location, organizer_id: @event.organizer_id, start_date: @event.start_date, title: @event.title, updated_at: @event.updated_at }
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get :show, id: @event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event
    assert_response :success
  end

  test "should update event" do
    patch :update, id: @event, event: { address: @event.address, agenda: @event.agenda, created_at: @event.created_at, end_date: @event.end_date, location: @event.location, organizer_id: @event.organizer_id, start_date: @event.start_date, title: @event.title, updated_at: @event.updated_at }
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, id: @event
    end

    assert_redirected_to events_path
  end
end
