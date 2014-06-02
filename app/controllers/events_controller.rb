class EventsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create,:update, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :accept_request, :reject_request ]
  before_action :event_owner!, only:[:edit,:update,:destroy]
  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @pending_requests = Attendance.where(event_id: Event.find_by_slug(params[:id]).id, state: 'request_sent')
    @attendees = Event.show_accepted_attendees(Event.find_by_slug(params[:id]).id)
    puts @attendees.inspect
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit

  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.organized_events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def all_tags=(names)
    self.tags = names.split(",").map do |t|
      Tag.where(name: t.strip).first_or_create!
    end
  end

  def join
    @attendance = Attendance.join_event(current_user.id, params[:event_id],'request_sent')
    'Request Sent' if @attendance.save
    redirect_to events_path
  end

  def accept_request
    @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
    @attendance.accept!
    'Applicant Accepted' if @attendance.save
    redirect_to events_path
  end

  def reject_request
    @attendance =  Attendance.find_by(id: params[:attendance_id]) rescue nil
    @attendance.reject!
    'Applicant Rejected' if @attendance.save!
    redirect_to events_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find_by_slug(params[:id])
    end

  def event_owner!
    authenticate_user!
    if @event.organizer_id != current_user.id
      redirect_to events_path
      flash[:notice] = 'You do not have enough permissions to do this'
    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :start_date, :end_date, :location, :agenda, :address, :organizer_id, :all_tags )
    end
end
