# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  rescue_from StandardError, with: :dispatch_error unless Rails.env.development?

  prepend_before_action :set_current_tenant

  def set_current_tenant
    @current_tenant = Tenant.where("lower(url) = ? OR lower(slug) = ?", request.host.downcase, request.subdomain.downcase).first
    SchemaTools.set_search_path(@current_tenant.id, true)
  end

  def dispatch_error(exception)
    case exception
    when ActiveRecord::RecordNotFound, ActionController::RoutingError
      render_404(exception)
    else
      render_500(exception)
    end
  end

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception} #{exception.message}"
    end
    render template: "errors/error_404", status: 404, layout: "application"
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.inspect}"
    end
    render template: "errors/error_500", status: 500, layout: "application"
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end
end
