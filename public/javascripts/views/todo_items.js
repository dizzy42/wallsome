wallsome.App = (function ($, public_) {

  public_.Views.TodoItems = Backbone.View.extend({
    el: $("#todo_list_11671104 .row"),

    initialize: function () {
      _.bindAll(this, "render");
    },

    render: function () {
      var collection = this.collection,
          el = $(this.el);

      collection.each(function(model) {
        var view = new wallsome.App.Views.TodoItem({
          model      : model
        });
        el.append(view.render().el);
      });

      return this;
    },

  });

  return public_;

})(jQuery, wallsome.App);
