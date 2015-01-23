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
  def find_duplicate_coordinates(lat, lon)
    Issue.where(lat: lat, lon: lon)
  end
end