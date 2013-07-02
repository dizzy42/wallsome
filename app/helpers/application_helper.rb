module ApplicationHelper
  def show_wallsome_header_link?
    !current_project.present?
  end

  def show_dashboard_link?
    controller_name != "basecamp_accountss" && params[:basecamp_account_name].present?
  end

  def new_item_link
    link_to("+ To-do Item", '#', :class => "button new_todo_item_link", :style => "background-color: #000; margin-right: 5px;")
  end

  def edit_item_link
    link_to('Edit', '#', :class => "edit_todo_item")
  end

  def delete_item_link
    link_to('Delete', '#', :class => "delete_todo_item")
  end

  def item_comments_link
    link_to('Comments', '#', :class => "todo_item_comments")
  end

  def item_comments_bubble_button(item)
    display_none = "display: none;" unless item.comments_count.try(">", 0)
    link_to(image_tag("blue_comment_bubble.png", :size => "20x20", :style => "float: right"),
            '#',
            :class => "todo_item_comments comment_icon_link",
            :style => display_none)
  end

  def month_day_optional_year(date)
    if date.year != Time.now.year
      date.strftime("%b %d, %Y")
    else
      date.strftime("%b %d")
    end
  end

  def highlight_current_milestone_tab?
    @milestone && @milestone == current_project.current_milestone
  end

  def highlight_milestones_tab?
     @milestones ||
    (@milestone && @milestone != current_project.current_milestone)
  end

  def highlight_backlog_tab?
    controller.controller_name == "backlogs" || (controller.controller_name != "columns" && @milestone.nil? && @milestones.nil?)
  end

  def highlight_columns_tab?
    controller.controller_name == "columns"
  end

  def basecamp_milestone_url(milestone)
    current_account.url + "milestones/#{milestone.id}/comments"
  end
end
