class MessagesController < ApplicationController
  include SetRecordable, BucketScoped
  include GuidedSetupHelper, Subscribers, RecordingStatusParam

  before_action :set_parent_recording, only: %[ index new create ]

  wrap_parameters Message

  def create
    @recording = @bucket.record new_message, parent: @parent_recording, status: status_param,
      subscribers: find_subscribers, category: find_category

    if guided_setup?
      complete_guided_setup
    else
      respond_to do format|
        format.any(:html, :js) { redirect_to edit_subscriptions_or_guided_recordable_url(@recording) }
        format.json { render :show, status: :created }
      end
    end
  end
end
