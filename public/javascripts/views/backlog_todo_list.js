wallsome.App = (function($, public_) {
  public_.Views.BacklogTodoList = Backbone.View.extend({
    tagName:   "div",
    className: "todo_list",
    events: {
      // "click .edit_todo_list":     "edit",
      // "click .delete_todo_list":   "delete"
    },

    initialize: function() {
      _.bindAll(this, "render");
    },

    render: function() {
      var view = ich.backlog_todo_list(todoListForTemplate(this)),
          that = this,
          $el  = $(this.el);
          
      $el.html(view);
      if ( this.model.get("completed") ) {
        $el.find(".todo_list_name h3").after("<span class=\"completed\">Completed</span>");
      }
      
      return this;
    },
    
    // edit: function(event) {
    //   window.Router.navigate(app.basecampAccountName + "/todo_lists/" + this.model.attributes.id + "/edit", true);
    //   event.preventDefault();
    // },
    // 
    delete: function(event) {
      var shouldDelete = confirm("Delete to-do list?");
      if (shouldDelete) {
        this.model.destroy();      
        $(this.el).slideUp("slow");
      }
      event.preventDefault();
    }
  
  });
  
  function todoListForTemplate(that) {
    var project = window.project;
    var data = {
      id:              that.model.get("id"),
      name:            that.model.get("name"),
      description:     that.model.get("description"),
      milestone_id:    that.model.get("milestone_id"),
      milestone_title: that.model.get("milestone_title"),
      columns:         project.get("columns"),
      project_id:      that.model.get("project_id")
    };
    return data;
  }

  return public_;

})(jQuery, wallsome.App);

