require 'my_lib_constants'
module CdsHelper
  
  def cd_ganre(sel_ganre)
    html = ''
    selected_id = []
    selected_id = sel_ganre.values unless sel_ganre.blank?
    CD_GANRE_HASH.each do |k, v|
    html += k + check_box_tag("cd_ganre[#{k}]", v, 
      selected_id.include?(v.to_s) ? true : false)
    end
    html.html_safe
  end
  
  
  def capital_option(c)
    html = ''
    CAPITALS.each do |capital|
      if c != nil && capital == c
        html += "<option selected='selected'>#{capital}</option>"
      else
         html += "<option>#{capital}</option>" 
      end
    end
    html.html_safe
  end
  
  def place_option(p)
    html = ''
    PLACES.each do |place|
      if place != nil && place == p
        html += "<option selected='selected'>#{place}</option>"
      else
        html += "<option>#{place}</option>"
      end
    end
    html.html_safe
  end
  
  def year_option(y)
    html = ''
    YEARS.each do |year|
      if y != nil && year.to_s == y
        html += "<option selected='selected'>#{year}</option>"
      else
        html += "<option>#{year}</option>"
      end  
    end
    html.html_safe
  end
  
  def check_admin?
    session[:admin] == 'admin'
  end
end
