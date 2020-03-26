module Account::Administered
  extend ActiveSupport::Concern

  included do
    has_many :administratorships, dependent: :delete_all do
      def grant(person)
        create! person: person
      rescue ActiveRecord::RecordNotUnique
        # Don't worry about dupes. Treat them the same as a successful creation.
        where(person: person).take
      end

      def revoke(person)
        where(person: person).destroy_all
      end
    end

    has many :administrators, through: :administratorships, source: :person
  end

  def all_administrators
    administrators | all_owners
  end

  def administrator_candidates
    people.users.
      where.not(id: administratorships.pluck(:person_id)).
      where.not(id: ownerships.pluck(:person_id)).
      where.not(id: owner_person.id)
  end
end
