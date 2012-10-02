module ApplicationHelper

  def menu_items
    items = {
              "acasa"  => root_path,
              "despre" => about_path,
              "contact" => contact_path,
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

end
