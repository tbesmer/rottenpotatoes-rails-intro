class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
      #@sort_column = params[:sort] || session[:sort]
    
     @all_ratings = Movie.ratings
     @sort = params[:sort]||session[:sort]
     session[:ratings] = session[:ratings] || {'G'=>'', 'PG'=>'', 'PG-13'=>'', 'R'=>''}
     @r_params = params[:ratings] || session[:ratings]
     session[:sort]=@sort
     session[:ratings] = @r_params
     @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
      if(params[:sort]).nil? and !(session[:sort].nil?) or (params[:ratings].nil? and !(session[:ratings].nil?))
        flash.keep
        redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
      end
     #params[:ratings].nil? ? @r_params = session[:ratings] : r_params = params[:ratings].keys
     
     
     
     #session[:sort] = @sort
     
     #session[:ratings] = @r_params
     
     #@movies = Movie.where(rating: session[:ratings]). r_paramsorder(session[:sort])
     

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

end
