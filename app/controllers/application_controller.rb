class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  alias_method :current_user, :current_manager
  add_breadcrumb 'Dashboard', :root_path
  helper_method :results?


  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
    end

    def require_mobile!
      unless current_manager.mobile_number
        redirect_to edit_manager_url(current_manager), alert: "Please enter your mobile phone " +
                                                              "number. Just enter a hyphen if " +
                                                              "you don't have a mobile."
      end
    end

  private

    def results?
      false
    end

end
