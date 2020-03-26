class Access < ActiveRecord::Base
  include Firehoseable

  belongs to :bucket, touch: :accesses_updated_at
  belongs to :person

  after destroy :reconnect_user
  after_destroy_commit :remove_inaccessible_records

  private
    def reconnect_user
      ActionCable.server.disconnect(current_user: person.user) if person.user?
    end

    def remove_inaccessible_records
      # 30s of forgiveness in case of accidental removal unless person.destroyed? || bucket.destroyed?
      Person::RemoveInaccessibleRecordsjob.set(wait: 30.seconds).perform_later(person, bucket)
    end
end
