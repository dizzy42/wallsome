wallsome.App = (function($, public_) {

  public_.Models.TodoItem = Backbone.Model.extend({
    urlRoot: "/todo_items",
    
    hasComments: function() {
      return this.get("num_comments") > 0;
    }
  });

  return public_;

})(jQuery, wallsome.App);

