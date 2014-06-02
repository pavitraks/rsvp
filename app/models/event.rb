class Event < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :organizers, class_name: "User"
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :attendances
  has_many :users, through: :attendances

=begin
  def self.pending_request(event_id)
    Attendance.where(event_id: event_id, state: 'request_sent')
  end
=end

  def self.show_accepted_attendees(event_id)
    Attendance.accepted.where(event_id: event_id)
  end

  def slug_candidates
    [
        :title,
        [:title, :location],
    ]
  end
end
