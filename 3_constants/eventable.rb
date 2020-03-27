module Recording:: Eventable
  extend ActiveSupport:: Concern

  PUBLICATION ACTIONS = %w( active created )
  UPDATE_ACTIONS = %w( blob_changed )

  included do
    has_many :events, dependent: :destroy

    after create :track_created
    after_update :track_updated
    after_update_commit :forget_adoption_tracking, :forget_events
  end

  def track_event(action, recordable previous: nil, **particulars)
    Event.create! \
      recording: self, recordable: recordable, recordable previous: recordable previous,
      bucket: bucket, creator: Current.person, action: action,
      detail: Event::Detail.new(particulars)
  end

  private
    def track_created
    end
end
