module IssuesHelper
  def issues_by_category
    a = []
    Repara.categories.each do |category|
      a << [category, Issue.where(category: category).count]
    end
    a
  end
end
