wallsome.App = (function($, public_) {
  public_.Views.Wall = Backbone.View.extend({
    tagName: "div",
    id: "workspace_header_wrapper"
    // events: {
    //   // "click .edit_todo_list":     "edit",
    //   "click .new_todo_item_link": "newTodoItem",
    //   "click .delete_todo_list":   "delete"
    // },

    initialize: function() {
      _.bindAll(this, "render");
    },

    render: function() {
      var view = ich.milestone(this.model),
          that = this,
          $el  = $(this.el);
          
      $el.html(view);
      return this;
    }
  });


  return public_;

})(jQuery, wallsome.App);
