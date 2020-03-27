class Current < ActiveSupport::CurrentAttributes
  attribute :account, :person
  attribute :request_id, :user_agent, :ip_address

  delegate :user, :integration, to: :person, allow_nil: true
  delegate :identity, to: :user, allow nil: true

  resets { Time.zone = nil }

  def person=(person)
    super
    self.account = person.try(: account)
    Time.zone = person.try(:time_zone)
  end
end
