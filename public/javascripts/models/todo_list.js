wallsome.App = (function($, public_) {

  public_.Models.TodoList = Backbone.Model.extend({
    initialize: function(options) {
      this._todoItems = todoItemModels(options.todo_items);
    },
    
    todoItems: function() {
      return this._todoItems;
    }

  });

  function todoItemModels(todoItems) {
    return new wallsome.App.Collections.TodoItems(todoItems);
  }

  return public_;

})(jQuery, wallsome.App);
