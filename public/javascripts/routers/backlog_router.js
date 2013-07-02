wallsome.App = (function ($, public_) {

  public_.Routers.BacklogRouter = Backbone.Router.extend({

    routes: {
      ":basecamp_account_name/projects/:project_id/backlog*query" : "backlog"
    },

    initialize: function () {
    },

    backlog: function(basecampAccountName, projectId, query) {
      window.todoLists.each(function(todoList) {
        var view = new wallsome.App.Views.BacklogTodoList({ model: todoList, id: "todo_list_" + todoList.id });
        $("#workspace_header").after(view.render().el);
      });
    }

  });

  return public_;

})(jQuery, wallsome.App);
