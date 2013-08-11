# encoding: UTF-8

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
  before_filter :validate_user
  
  helper_method :select_items
  #before_filter :select_items
  
  private
  
    def validate_user
      if User.any? and not current_user.has_any_role?(:user, :admin)
        redirect_to :back, alert: "No tienes permisos para acceder a esta sección."
      end
    end
  
    def select_items
      @start_date = Date.parse "01/01/#{(params[:date].blank? or params[:date].empty?) ? '2013' : params[:date][:year]}"
      @product = Product.find params[:product_id] unless params[:product_id].blank? or params[:product_id].nil?
      @client = Client.find params[:client_id] unless params[:client_id].blank? or params[:client_id].nil?
      @client_type = ClientType.find params[:client_type_id] unless params[:client_type_id].blank? or params[:client_type_id].nil?
      return Invoice.total_items(@start_date, @start_date.end_of_year, (@product.nil? ? nil : @product.id), (@client.nil? ? nil : @client.id), (@client_type.nil? ? nil : @client_type.id))
    end
end
