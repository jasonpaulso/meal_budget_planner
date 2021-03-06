class MealsController < ApplicationController

  get '/meals/new' do
    if logged_in?
      @title = "MealPost"
      erb :"/meals/new"
    else
      flash[:error] = "You'll need to login or signup if you want to add a meal."
      redirect "/"
    end
  end

  get '/meals/index' do 
    @title = "MealFeed"
    if meals_empty?
      redirect '/meals/new'
    else
      erb :"/meals/index"
    end
  end

  get '/meals/:id/edit' do
    @meal = find_meal
    @title = "Edit Meal"
    if editable?
      erb :"/meals/edit"
    else
      erb :"/meals/error"
    end
  end

  get '/meals/:id' do 
    @meal = find_meal
    @title = "#{@meal.name} by #{@meal.username}"
    erb :"/meals/show"

  end

  post "/meals" do 
    @meal = Meal.new(params[:meal])
    update_or_add_ingredients
    @meal.save
    current_user.meals << @meal
    if !@meal.id.nil? 
      redirect to "/meals/#{@meal.id}"
    else
      flash[:error] = @meal.errors.messages
      redirect to '/meals/new'
    end
  end

  patch '/meals/:id' do
    @meal = find_meal
    @meal.update(params[:meal])
    update_or_add_ingredients
    @meal.save
    redirect "/meals/#{@meal.id}"
  end

  delete '/meals/:id/delete' do
    @meal = find_meal
    @meal.destroy
    redirect to '/meals/index'
  end

  get '/meals/:id/duplicate' do
    @meal = duplicate_meal
    redirect to "/meals/#{@meal.id}/edit"
  end
  
  get '/meals/*' do
    erb :"/meals/error"
  end


end






