module ApplicationHelper

  def dropdown_list items
    result = "" 

    items.each do |item|
      #TODO speak with catalin about the href. use ajax backgroud requests?
      result += "<li>" + link_to(item.name, show_cat_path(item.id)) + "</li>"
    end

    return result.html_safe
  end

  # TODO use translations
  def current_category
    Category.find_by_id(params[:id]).try(:name) || "Toate categoriile"
  end

end
