wallsome.App = (function ($, public_) {

  public_.Routers.WallRouter = Backbone.Router.extend({

    routes: {
      ":basecamp_account_name/projects/:project_id/milestones/current" : "milestone",
      ":basecamp_account_name/projects/:project_id/milestones/:id"     : "milestone"
    },

    initialize: function () {
    },

    milestone: function(basecampAccountName, projectId) {
      window.todoLists.each(function(todoList) {
        var view = new wallsome.App.Views.TodoList({ model: todoList, id: "todo_list_" + todoList.id });
        $("#workspace_header").after(view.render().el);
      });
    }

  });

  return public_;

})(jQuery, wallsome.App);
