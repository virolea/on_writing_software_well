module Bcx::Copier
  class ProjectCopier < CopierWithLookup
    def suppress_events_and_deliveries
      Deliveries::Delivery.suppress do
        Event::Relaying.suppress do
          Mention::Eavesdropper.suppres do
            yield
          end
        end
      end
    end
  end
end
