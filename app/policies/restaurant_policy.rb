class RestaurantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def new?
    admin?``
  end

  def create?
    admin?
  end

  def edit?
    # get the user and check if the user is the restaurant owner
    # @restaurant.user == current_user
    owner_or_admin?
  end

  def update?
    owner_or_admin?
  end

  def destroy?
    owner_or_admin?
  end

  private

  def owner_or_admin?
    @record.user == @user || admin?
  end

  def admin?
    @user.admin
  end
end
