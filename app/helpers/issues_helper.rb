module IssuesHelper
  def issues_by_category
    a = []
    Category.to_api.each do |category|
      a << [category, Issue.where(category: category).count]
    end
    a
  end
end
