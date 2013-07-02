wallsome.App = (function($, public_) {

  public_.Collections.Columns = Backbone.Collection.extend({
    model: wallsome.App.Models.Column
  });

  return public_;

})(jQuery, wallsome.App);
