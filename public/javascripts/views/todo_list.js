wallsome.App = (function($, public_) {
  public_.Views.TodoList = Backbone.View.extend({
    tagName:   "div",
    className: "todo_list",
    events: {
      "click .new_todo_item_link": "newTodoItem",
      "click .delete_todo_list":   "delete"
    },

    initialize: function() {
      _.bindAll(this, "render", "renderTodoItems", "remove");

      this.model.todoItems().bind("add", this.render);
    },

    render: function() {
      var view = ich.todo_list(todoListForTemplate(this)),
          that = this,
          $el  = $(this.el);

      $el.html(view);
      if ( this.model.get("completed") ) {
        $el.find(".todo_list_name h3").after("<span class=\"completed\">Completed</span>");
      }

      setColumnStyles(that);
      this.renderTodoItems();
      return this;
    },

    delete: function(event) {
      var shouldDelete = confirm("Delete to-do list?");
      if (shouldDelete) {
        this.model.destroy();
        $(this.el).slideUp("slow");
      }
      event.preventDefault();
    },

    renderTodoItems: function() {
      var that = this,
          columnViews = [];
      window.columns.each(function(column) {
        var columnView = new wallsome.App.Views.TodoListColumn({
          collection:  todoItemsForColumn(column, that),
          model:       column,
          columnWidth: columnWidth(that)
        });
        columnViews.push(columnView.render().el);
      });
      var firstColumnView = columnViews[0];
      $(firstColumnView).css("margin-left", "20px");
      $(that.el).find(".row").append(columnViews);
    },

    newTodoItem: function(event) {
      if (!app.TodoItem.Dialog) return false;

      var form = app.TodoItem.Dialog.find("form"),
          formContent = app.TodoItem.Dialog.find("#todo_item_content"),
          that = this,
          todoList = $(this.el);

      app.TodoItem.Dialog.dialog('option', {
        title: 'New to-do item',
        open: function() {
          setupForm(form, formContent, that);
          setupSubmitButton(form, formContent, todoList);
        }
      });

      app.TodoItem.Dialog.dialog('open');
      formContent.focus();
      return false;
    }

  });


  function setColumnStyles(that) {
    var viewColumnHeaders = _.toArray($(that.el).find(".col_header_row .col_header")),
        firstCol = viewColumnHeaders.shift(),
        lastCol = viewColumnHeaders.pop();

    $(firstCol).attr("style", "width: " + columnWidth(that) + "%; border-right: 1px dotted #000; margin-left: 20px");
    $(lastCol).attr("style", "width: " + columnWidth(that) + "%; margin-left: 10px");
    _.each(viewColumnHeaders, function(col) {
      $(col).attr("style", "width: " + columnWidth(that) + "%; border-right: 1px dotted #000; margin-left: 10px");
    });
  }

  function columnWidth(that) {
    return Math.floor(93 / window.columns.size());
  }

  function todoItemsForColumn(column, that) {
    return todoItems(that).select(function(item) {
      return item.get("column_id") == column.get("id");
    });
  }

  function todoItems(that) {
    return that.model.todoItems();
  }

  function todoListForTemplate(that) {
    var data = {
      id:              that.model.get("id"),
      name:            that.model.get("name"),
      description:     that.model.get("description"),
      milestone_id:    that.model.get("milestone_id"),
      milestone_title: that.model.get("milestone_title"),
      columns:         window.columns.toJSON(),
      project_id:      that.model.get("project_id")
    };
    return data;
  }

  function setupForm(form, formContent, that) {
    var formMethod = form.find("input[name='_method']");

    form.attr("action", that.model.url() + "/todo_items");
    formMethod.val("post");
    formContent.val("");
    form.find("option").removeAttr("selected");
    form.find("option:first").attr("selected", "selected");
  }

  function setupSubmitButton(form, formContent, todoList) {
    var submitButton = $('#todo_item_dialog_submit');
    submitButton.text("Create");

    submitButton.unbind(); // Prevent previous handlers on the shared button from being executed
    submitButton.click(function() {
      var content = formContent.val(),
          formResponsibleParty = form.find("#todo_item_responsible_party");
          responsiblePartyId = formResponsibleParty.find("option:selected").val();

      if (!content) {
        alert("Please enter a text for the to-do item.");
        formContent.focus();
        return false;
      }

      app.spinner.dialog('open');

      postForm(form, content, todoList, responsiblePartyId);
      return false;
    });
  }

  function postForm(form, content, todoList, responsiblePartyId) {
    $.post(form.attr("action"), form.serialize(),
       function(data) {
         var data = data.todo_item; // rails now returns the json => { todo_item : {} }
         fromSubmitSuccess(data, content, todoList, responsiblePartyId);
       }
    );
  }

  function fromSubmitSuccess(data, content, todoList, responsiblePartyId) {
    var item = new wallsome.App.Models.TodoItem({
      id:                     data.id,
      content:                content,
      responsible_party_name: app.responsiblePartyMap[responsiblePartyId],
      responsible_party_id:   responsiblePartyId,
      column:                 "open",
      num_comments:           0
    });
    var view = new wallsome.App.Views.TodoItem({ model: item, id: "todo_item_" + item.get("id") }).render().el;

    todoList.find(".row .open").append(view);
    app.spinner.dialog('close');
    $(view).fadeIn('fast');
    $(".col").sortable('refresh');
    app.TodoItem.Dialog.dialog("close");
  }

  return public_;

})(jQuery, wallsome.App);

