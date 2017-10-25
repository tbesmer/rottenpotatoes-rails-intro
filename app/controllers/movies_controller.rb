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
    
     #@all_ratings = Movie.ratings
     #@sort = params[:sort]||session[:sort]
     #session[:ratings] = session[:ratings] || {'G'=>'', 'PG'=>'', 'PG-13'=>'', 'R'=>''}
     #@r_params = params[:ratings] || session[:ratings]
     #session[:sort]=@sort
     #session[:ratings] = @r_params
     #@movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
     # if(params[:sort]).nil? and !(session[:sort].nil?) or (params[:ratings].nil? and !(session[:ratings].nil?))
        #flash.keep
        #redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
    #  end
     #params[:ratings].nil? ? @r_params = session[:ratings] : r_params = params[:ratings].keys
     
     #session[:sort] = @sort
     #session[:ratings] = @r_params
     #@movies = Movie.where(rating: session[:ratings]). r_paramsorder(session[:sort])
     
     #sort = params[:sort] || session[:sort]
    #case sort
    #when 'title'
      #ordering = {:title => :asc}
      #@title_header = 'hilite'
    #when 'release_date'
      #ordering = {:release_date => :asc}
      #@release_date = 'hilite'
    #end
    
    #@all_ratings = Movie.ratings;
    #@selected_ratings = params[:ratings] || session[:ratings] || {}
    
    #if @selected_ratings == {}
     # @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    #end
    
    #if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
     # session[:sort] = sort
      #session[:ratings] = @selected_ratings
      #flash.keep
      #redirect_to :sort => sort, :ratings => @selected_ratings and return
    #end
    
    #@movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
     
      need_redirect = false
    @all_ratings = Movie.get_all_ratings
    ratings = params[:ratings] || session[:ratings] || {}
    if ratings != {}
      @ratings = ratings
    else
      @ratings = Hash.new
      @all_ratings.each {|r| @ratings[r] = 1}
    end
    if params[:ratings]
      session[:ratings] = @ratings
    elsif session[:ratings]
      need_redirect = true
    end
    
    sort_by = params[:sort_by] || session[:sort_by]
    if params[:sort_by]
      session[:sort_by] = sort_by
    elsif session[:sort_by]
      need_redirect = true
    end

    if need_redirect
      redirect_to :sort_by => sort_by, :ratings => @ratings
    end

    if sort_by == "title" 
      @movies = Movie.where(rating: @ratings.keys).order("title ASC")
      @title_class = "hilite"
    elsif sort_by == "release_date"
      @movies = Movie.where(rating: @ratings.keys).order("release_date ASC")
      @release_date_class = "hilite"
    else
      @movies = Movie.where(rating: @ratings.keys)
    end
     
     

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
