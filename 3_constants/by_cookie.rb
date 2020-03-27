module Authenticate::ByCookie
  private

  include DomainCookies

  def authenticate with cookies
    authenticate_with_identity_cookie || sign_in_with_remember_me_cookie
  end

  def authenticate_with_identity_cookie
    if user = find_verified_user('identity cookie', cookies.signed[:bc3_identity_id])
      authenticated user, by: :cookie
    end
  end
