class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  def index
    # @restaurants = Restaurant.all
    # Because of the Scope rules that I have inside my RestaurantPolicy
    # There two lines are EXACLTY the same thing!!!!!!
    @restaurants = policy_scope(Restaurant)

    # IF we don't use the Pundit Scope methods,
    # we could just use the following strategy:

    # 3) Worst option
    # @restaurants = Restaurant.all.select do |r|
    #   r.user == current_user
    # end

    # 2) Second worst option
    # @restaurants = Restaurant.where(user: current_user)

    # 1) The winning and optimal option!
    # @restaurants = current_user.restaurants
    
  end

  def show
    authorize @restaurant
  end

  def new
    @restaurant = Restaurant.new
    authorize @restaurant
  end

  def edit
    authorize @restaurant
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    authorize @restaurant

    if @restaurant.save
      redirect_to @restaurant, notice: 'Restaurant was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @restaurant
    if @restaurant.update(restaurant_params)
      redirect_to @restaurant, notice: 'Restaurant was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @restaurant
    @restaurant.destroy
    redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.'
  end

  private

    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name)
    end
end
