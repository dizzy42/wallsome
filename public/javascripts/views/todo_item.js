wallsome.App = (function($, public_) {

  public_.Views.TodoItem = Backbone.View.extend({
    tagName:   "div",
    className: "todo_item",
    events: {
      "mouseenter"             : "showActions",
      "mouseleave"             : "hideActions"//,
      // "click .edit_todo_item"  : "edit",
      // "click .delete_todo_item": "delete"
    },
    
    initialize: function() {
      _.bindAll(this, "render");
    },

    render: function() {
      var view = ich.todo_item(this.model.attributes),
          $el  = $(this.el);
      if ( app.currentPersonId == this.model.get("responsible_party_id") ) {
        $el.addClass("responsible_for_item");
      }
      
      $el.html(view);

      if ( this.model.hasComments() ) {
        $el.find(".todo_item_comments").show();
      }
      return this;
    },
    
    showActions: function(event) {
      $(this.el).find(".todo_item_actions").show();
    },
    
    hideActions: function(event) {
      $(this.el).find(".todo_item_actions").hide();
    },
    
    edit: function(event) {
      window.Router.navigate("todo_lists/" + this.model.attributes.todoListId + "/todo_items/" + this.model.attributes.id + "/edit", true);
      event.preventDefault();
    },
    
    delete: function(event) {
      var shouldDelete = confirm("Delete to-do list?");
      if (shouldDelete) {
        this.model.destroy();
        this.remove(); // TODO: remove once we are integrated in wallsome
      }
      event.preventDefault();
    }

  });
  
  return public_;

})(jQuery, wallsome.App);
