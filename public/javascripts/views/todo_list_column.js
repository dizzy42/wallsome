wallsome.App = (function($, public_) {

  public_.Views.TodoListColumn = Backbone.View.extend({
    tagName: "div",
    className: "col",

    initialize: function() {
      _.bindAll(this, "render");

      this.columnWidth = this.options.columnWidth;
    },

    render: function() {
      var that = this,
          $el = $(this.el);

      $el.attr("style", "width: " + this.columnWidth + "%; margin-left: 10px");
      $el.addClass("connected_sortable").addClass(this.model.get("id"));

      $el.sortable({
        connectWith: ".connected_sortable",
        distance: 10, // Tolerance, in pixels, for when sorting should start -- feels smoother

        // we cannot use receive here, because receive only happens when an element is moved from
        // one list to another. However, we want to also update the order of items within a list.
        update: function(event, ui) {
          // this ensures only one update happens, because each effected list fires an update event.
          if (this === ui.item.parent()[0]) {
            var todoItem = ui.item,
                todoList = todoItem.closest(".todo_list"),
                todoItemIds = app.TodoListMethods.getTodoItemIds(todoList);;
            _postSort(that, todoList, todoItem, todoItemIds);
          }
        }
      }).disableSelection();

      // TODO: Turn this collection into a proper collection
      // right now it is just an array of todo items
      _.each(this.collection, function(item) {
        var view = new wallsome.App.Views.TodoItem({ model: item, id: "todo_item_" + item.get("id") });
        $(that.el).append(view.render().el);
      });
      return this;
    }

  });

  function _postSort(that, todoList, todoItem, todoItemIds) {
    var url = '/' + app.basecampAccountName + '/todo_lists/' +
              app.TodoListMethods.todoListId(todoList) + '/todo_items/' +
              app.TodoItemMethods.todoItemId(todoItem) + '/move';

    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: url,
        data: _data(that, todoItem, todoItemIds),
        success: function(data, textStatus ) {
           // do nothing special for now
        },
        error: function(xhr, textStatus, errorThrown) {
          if (xhr.status == 404) {
            alert("It seems the to-do item: " + todoItem.find("p").first().html() + " has been deleted.");
            todoItem.remove();
          } else{
            alert("An error occurred while trying to update the to-do item.");
          }
        }
    });
  };

  function _data(that, todoItem, todoItemIds) {
    return { _method: "PUT",
             todo_item: {
               column_id: that.model.get("id")
             },
             ordered_todo_item_ids: todoItemIds
           };
  };


  return public_;

})(jQuery, wallsome.App);
