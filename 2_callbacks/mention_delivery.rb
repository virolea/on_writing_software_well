class Deliveries::MentionDelivery < Deliveries::Delivery
  protected
    def notification
      MentionsNotifier.mention(deliverable, recipient)
    end

    def mail
      MentionsNotifier.mention(deliverable)
    end
end
