module ApplicationHelper

  def menu_items
    items = {
              "documentatie" => apipie_path,
            }

    result = ""

    items.each do |item_name, url|
      if current_uri == url
        result += "<li class='active'><a href='#{url}'>#{item_name.capitalize}</a></li>"
      else
        result += "<li><a href='#{url}'>#{item_name.capitalize}</a></li>"
      end
    end

    return result.html_safe
  end


  def dropdown_list items
    result = "" 

    items.each do |item|
      #TODO speak with catalin about the href. use ajax backgroud requests?
      result += "<li><a tabindex='-1' href='#'>#{item.name}</a></li>"
    end

    return result.html_safe
  end

end
