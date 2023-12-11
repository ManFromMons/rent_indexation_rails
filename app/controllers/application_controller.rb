class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale

  before_action :cors_set_access_control_headers

  # rubocop:disable Metrics/AbcSize
  def cors_set_access_control_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] =
      'Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, X-User-Token, X-User-Email'
    response.headers['Access-Control-Max-Age'] = '1728000'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
  end
  # rubocop:enable Metrics/AbcSize
end
