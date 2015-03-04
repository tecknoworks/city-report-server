# The curator is a class responsible for finding duplicate or similar reported issues.
#
# == This class provides the following answers:
#
# * Which are the issues with duplicate coordinates?
# * Are there issues with duplicate data?
# * Are two coordinates so close together that they represent the same issue?
# * Find all coordinate pairs which are close together.
#
class Curator
  def find_duplicate_coordinates(category, lat, lon)
    # 0.000040233 =~ 5m in lat
    # 0.000020208 =~ 5m in lon
    Issue.where({
      category: category, 
        :lat.lt => lat + 0.000040233, 
        :lat.gt => lat - 0.000040233, 
        :lon.lt => lon + 0.000020209, 
        :lon.gt => lon - 0.000020209
    })
  end
end
