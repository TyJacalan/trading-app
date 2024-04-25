module TimeHelper
  def time_ago(datetime)
    time_difference_in_seconds = Time.now - datetime
    if time_difference_in_seconds >= 3600
      time_difference_in_hours = (time_difference_in_seconds / 3600).to_i
      "#{time_difference_in_hours} #{'hour'.pluralize(time_difference_in_hours)} ago"
    elsif time_difference_in_seconds >= 60
      time_difference_in_minutes = (time_difference_in_seconds / 60).to_i
      "#{time_difference_in_minutes} #{'minute'.pluralize(time_difference_in_minutes)} ago"
    else
      "#{time_difference_in_seconds} #{'second'.pluralize(time_difference_in_seconds)} ago"
    end
  end
end
