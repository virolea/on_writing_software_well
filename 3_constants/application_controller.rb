class ApplicationController < ActionController::Base
  include PublicKeyPinning, HttpClientHints
  include BlockSearchEngineIndexing
  include MakaraContextControl
  include SetCurrentRequestDetails

  include SetVariant
  include ProceedToLocation

  include RequireAccount
  include Authenticate
  include ApiRequest
  include ForgeryProtection

  include RetryJbuilderErrors
  include ErrorResponses
  include SendExceptionsToSentry

  include EtagForCurrentPerson
  include EtagForCurrentEnvironment
  include AssetFreshness, AssetReferences
  include FragmentCachingByAccount
  include ChromelessLayout
  include TurbolinksCacheControl

  include Anchoring

  include Appearances
end
