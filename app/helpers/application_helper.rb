module ApplicationHelper

  def dropdown_list items
    result = "" 

    items.each do |item|
      #TODO speak with catalin about the href. use ajax backgroud requests?
      result += "<li><a tabindex='-1' href='#'>#{item.name}</a></li>"
    end

    return result.html_safe
  end

end
