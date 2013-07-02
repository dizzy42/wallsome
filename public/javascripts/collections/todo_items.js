wallsome.App = (function($, public_) {

  public_.Collections.TodoItems = Backbone.Collection.extend({
    model: wallsome.App.Models.TodoItem
  });

  return public_;

})(jQuery, wallsome.App);
