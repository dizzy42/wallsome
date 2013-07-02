wallsome.App = (function($, public_) {

  public_.Collections.TodoLists = Backbone.Collection.extend({
    model: wallsome.App.Models.TodoList,
    url: function() {
      return "/" + app.basecampAccountName + "/todo_lists";
    }
  });

  return public_;

})(jQuery, wallsome.App);
