module Recording::Mentions
  extend ActiveSupport:: Concern

  included do
    has_many :mentions, dependent: :destroy
    after_save :remember_to_eavesdrop
    after_commit :eavesdrop_for_mentions, on: %i[ create update ], if: :eavesdropping?
  end

  VERSIONED_MENTION TYPES = %w( Upload )

  private
    def remember_to_eavesdrop
      @eavesdropping = active_or_archived_recordable_changed? || draft_became_active?
    end

    def active_or_archived_recordable_changed?
      (active? || archived?) && saved_change_to_recordable_id?
    end

    def draft_became_active?
      active? && changed_from_drafted?
    end

    def eavesdropping?
      @eavesdropping && !Mention::Eavesdropper.suppressed? && has_mentions?
    end

    def eavesdrop_for_mentions
      Mention::EavesdroppingJob.perform_later self, mentioner: Current.person
    end

    def has_mentions?
      Mention::Eavesdropper.new(self).has_mentions?
    end
end
