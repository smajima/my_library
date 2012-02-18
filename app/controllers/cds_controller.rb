# encoding:utf-8
require 'my_lib_constants'
require 'digest/sha1'

class CdsController < ApplicationController
 SAVE_SEARCH = %w(cd_ganre title capital artist place year) 
 
  def index
    SAVE_SEARCH.each do |name|
      session[name.to_sym] = nil
    end
    render 'search'
  end
  
  def new
    @cd = Cd.new
  end
  
  def create
    params_convert
    @cd = Cd.new(params[:cd])
    if @cd.valid?
      @cd.save
    else
      render 'new'
    end
  end
  
  def edit
    @cd = Cd.find(params[:id])
  end
  
  def update
    params_convert
    @cd = Cd.find(params[:id])
    unless @cd.update_attributes(params[:cd])
      render 'edit'
    else
      redirect_to search_cds_path
    end
  end
  
  def check_admin
    session[:admin] = 'normal'
    session[:admin] = 'admin' if HEX_DIGEST == Digest::SHA1.hexdigest(params[:keyword])
    render 'index'
  end
  
  def search
    # set per_page globally
    #WillPaginate.per_page = PAGINATION_SIZE
    #WillPaginate.per_page = 3
    if params[:from_keyboard].blank?
      return
    end
    p params.inspect
    search_string = []
    search_param = []
    ganre_string = ''
    unless params[:cd_ganre].blank?
      ganre_ids = params[:cd_ganre].values
      ganre_string = ganre_ids.join(",")
      ganre_string = "ganre in (#{ganre_string})"
      search_string << ganre_string
    end
    
    title_string = ''
    title_param = ''
    unless params[:title].blank?
      title_string = 'title = ?'
      title_param = "%#{params[:title]}%".upcase!
      search_string << title_string
      search_param << title_param
    end
    
    capital_string = ''
    captal_param = ''
    unless params[:capital].blank?
      capital_string = 'capital = ?'
      capital_param = params[:capital]
      search_string << capital_string
      search_param << capital_param
    end
    
    artist_string = ''
    unless params[:artist].blank?
      artist_string = 'artist = ?'
      artist_param = "%#{params[:artist]}%".upcase!
      search_string << artist_string
      search_param << artist_param
    end
    
    place_string = ''
    unless params[:place].blank?
      place_string = 'place = ?'
      place_param = params[:place]
      search_string << place_string
      search_param << place_param
    end
    
    year_string = ''
    unless params[:year].blank?
      year_string = 'issued_year = ?'
      year_param = params[:year]
      search_string << year_string
      search_param << year_param
    end    
    search_string = search_string.join(" AND ") unless search_string.blank?
    
    SAVE_SEARCH.each do |param|
      session[param.to_sym] = params[param.to_sym]
    end
    
    if search_param.size == 0 && search_string.blank?
      @cds = Cd.paginate(:page => params[:page], :per_page => PAGINATION_SIZE).order('artist_for_sort ASC')
    else
      puts search_string
      puts search_param[0]
      @cds = Cd.where(search_string, *search_param).paginate(:page => params[:page], :per_page => PAGINATION_SIZE).order('artist_for_sort ASC')     
    end  
  end
  
  def destroy
    @cd = Cd.find(params[:id])
    @cd.destroy
    render 'search'
  end
  
  private
  
  def params_convert
    unless params[:cd][:artist].blank?
      artist = params[:cd][:artist]
      artist.lstrip!
      params[:cd][:artist] = artist.upcase
    end
    unless params[:cd][:title].blank?
      title = params[:cd][:title]
      title.lstrip!
      params[:cd][:title] = title.upcase
    end
    artist = params[:cd][:artist]
    unless artist.blank?
      artist_for_sort = artist.dup
      artist_for_sort.slice!('THE')
      artist_temp = artist_for_sort.lstrip!
      params[:cd][:artist_for_sort] = artist_temp == nil ? artist_for_sort : artist_temp
      params[:cd][:capital] = artist_for_sort[0]
    end    
  end
end
