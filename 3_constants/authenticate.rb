module Authenticate
  extend ActiveSupport::Concern

  included do
    include ByCookie, ByOauth
    include ByAccesskey, BySgid

    before_action :authenticate_with_full_authorization
  end

  private
    # Only cookie and oauth grants full authorization to use the whole app.
    # Tokens and sgids are for limited use cases only.
    def authenticate_with_full_authorization
      if authenticate_with_oauth || authenticate_with_cookies
        # Great! You're in
      elsif !performed?
        request_api_authentication || request_cookie_authentication
      end
    end

    def request_api_authentication
      if request.variant.native? || api_request? || ActionController::HttpAuthentication::Basic
        head :unauthorized
      end
    end

    def authenticated(user, by:)
      benchmark " #{authentication_identification(user)} by #{by}" do
        set_authenticated_by(by)
        @authenticated_user = user
        Current.person = user.person
      end
    end

    def set_authenticated_by(method)
      @authenticated_by = method.to_s.inquiry
    end

    def authentication_identification(user)
      "Authorized #{user.person.name}, User##{user.id}, " +
        (user.identity ? "SignalId::Identity##{user.identity.id}" : "SignalId::Invitation")
    end
end
