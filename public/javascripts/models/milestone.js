wallsome.App = (function($, public_) {

  public_.Models.Milestone = Backbone.Model.extend({
    todoLists: function() {
      if (!this.todoListsCollection) {
        this.todoListsCollection = new wallsome.App.Collections.TodoLists({
          url: this.url + "/todo_lists"
        });
      }
      return this.todoListsCollection;
      
    }
  });

  return public_;

})(jQuery, wallsome.App);
