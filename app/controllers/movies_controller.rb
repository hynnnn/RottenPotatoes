class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    ratings = params[:ratings]
    @order = params[:order]
    if ratings != nil then
        session[:ratings] = ratings
    end
    if @order != nil then
        session[:order] = @order
    end
    if params[:commit]!='Refresh' then
        ratings = session[:ratings]
        @order = session[:order]
    else
        session[:ratings] = ratings
        session[:order] = @order
    end
    @ratings_to_show = Movie.all_ratings
    if ratings != nil then 
        ratings = ratings.keys 
        @ratings_to_show = ratings
    end
    @movies = Movie.with_ratings(ratings)
    if @order != nil then
        @movies = @movies.order(@order)
    end
    @all_ratings = Movie.all_ratings
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
