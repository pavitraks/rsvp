class Attendance < ActiveRecord::Base

  scope :accepted, -> {where(state: 'accepted')}
  include Workflow
  workflow_column :state

  workflow do
    state :request_sent do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :accepted
    state :rejected
  end

  belongs_to :event
  belongs_to :user

  def self.join_event(user_id,event_id,state)
    self.create(user_id: user_id, event_id: event_id, state: state)
  end
end
