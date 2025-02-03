module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice
      'blue'
    when :danger, :alert
      'red'
    else
      'gray'
    end
  end
end
