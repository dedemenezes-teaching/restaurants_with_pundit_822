class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include Pundit  # This allows us to use the authorize method inside all controllers

  # This will enforce that you called authorize inside every single controller actions
  # (except the index ones)
  after_action :verify_authorized, except: :index, unless: :skip_pundit?

  # This will enforce that you called Scope methods inside every single index actions
  # (So, if you don't want to use the Policy Scope, remove this line from here)
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
