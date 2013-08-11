module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(sort: column, direction: direction, page: nil), { class: css_class }
  end
  
  def tabbable(link, title = nil)
    title ||= link.titleize
    link_to title, params.merge(type: link, page: nil), { data: { toggle: "tab" }, class: "tabbable" }
  end
  
  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
    else
      flash_type.to_s
    end
  end
end
