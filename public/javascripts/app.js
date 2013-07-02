wallsome.App  = (function ($, public_) {

  public_.Models = {};
  public_.Collections = {};
  public_.Views = {};
  public_.Routers = {};
  public_.wallInit = function (columns, todoLists) {
    window.columns = new wallsome.App.Collections.Columns(columns);
    window.todoLists = new wallsome.App.Collections.TodoLists(todoLists);
    window.Router = new public_.Routers.WallRouter();

    Backbone.history.start({ pushState: true });
  };

  public_.backlogInit = function (todoLists) {
    window.project = new wallsome.App.Models.Project({
      columns: [ { name: "Open", state: "open" },
                 { name: "In Progress", state: "in_progress" },
                 { name: "Completed", state: "completed" }]
    });

    window.todoLists = new wallsome.App.Collections.TodoLists(todoLists);
    window.Router = new public_.Routers.BacklogRouter();

    Backbone.history.start({ pushState: true });
  };

  return public_;

})(jQuery, wallsome.App || {});

