module DashboardHelper

  # Check if object still exists in the database and display a link to it,
  # otherwise display a proper message about it.
  # This is used in activities that can refer to
  # objects which no longer exist, like removed posts.
  def link_to_trackable(object, object_type)
    if object
      link_to object, object
    else
      "a #{object_type.downcase} which does not exist anymore"
    end
  end

end
