require 'exceptions/exceptions'
class ApplicationController < ActionController::Base
  before_action :authenticate_user
  before_action :set_company

  def authenticate_user
    begin
      @current_user = User.find(request.headers['Authorization'])
    rescue ActiveRecord::RecordNotFound
      raise Exceptions::AuthenticationError
    end
  end

  def current_user
    @current_user
  end

  def set_company
    @company = current_user.company
  end

  rescue_from Exceptions::InvalidParams, Exception, StandardError do |e|
    render json: {
        message: "A server error occured while completing your request. #{e.message}"
    }, status: 400
  end

  rescue_from Exceptions::AuthenticationError do |e|
    render json: {
        message: "An authentication error occured while completing your request. #{e.message}"
    }, status: 401
  end

  rescue_from Exceptions::AuthorizationError do |e|
    render json: {
        message: "An authorization error occured while completing your request. #{e.message}"
    }, status: 401
  end

end

