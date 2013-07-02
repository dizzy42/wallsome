app.TodoListMethods = {};

app.TodoListMethods.todoListPath = function(id) {
  return '/' + app.basecampAccountName + '/todo_lists/' + id;
};

app.TodoListMethods.deleteTodoList = function(todoList){
  shouldDelete = confirm("Delete to-do list?");
  if (shouldDelete) {
    var data = { "_method": "delete" };

    todoList.slideUp('slow', function() {
      $.post(app.TodoListMethods.todoListPath(app.TodoListMethods.todoListId(todoList)), data, function() {
        todoList.remove();
      });
    });
  }
};

app.TodoListMethods.getTodoItemIds = function(todoList) {
  var ids = todoList.find(".todo_item").map(function() {
    return app.TodoItemMethods.todoItemId($(this));
  });
  return ids;
};

app.TodoListMethods.todoListId = function(todoList) {
  return todoList.attr("id").slice(10);
};


app.TodoListMethods.deleteTodoListBehavior = function(links) {
  links.live('click', function() {
    var deleteButton = $(this),
        todoList = deleteButton.closest(".todo_list");

    app.TodoListMethods.deleteTodoList(todoList);

    deleteButton.blur();
    return false;
  });  
};


// Editing a to-do list
app.TodoListMethods.editTodoListBehavior = function(links, keepTodoListWithDifferentMilestone) {
  links.live('click', function() {
    if (!app.TodoList.Dialog) return false;
    
    var todoList = $(this).closest(".todo_list"),
        todoListNameElement = todoList.find("h3"),
        dialogListName = app.TodoList.Dialog.find("#todo_list_name"),
        dialogListDescription = app.TodoList.Dialog.find("#todo_list_description"),
        dialogMilestoneLabel = app.TodoList.Dialog.find("label[for='todo_list_milestone']"),
        dialogMilestoneSelector = app.TodoList.Dialog.find("#todo_list_milestone_id");
        todoListMilestoneId = todoList.find("span.milestone_title").attr("data-milestone-id");

    var submitButton = $('#todo_list_dialog_submit');
    submitButton.text("Update");

    submitButton.unbind(); // Prevent previous handlers on the shared button from being executed
    submitButton.click(function(event) {
      _updateName(todoList, todoListNameElement, dialogListName, dialogListDescription, dialogMilestoneSelector);
      return false;
    });

    app.TodoList.Dialog.dialog('option', {
      title: 'Edit to-do list',
      open: function() {
        dialogMilestoneSelector.val(todoListMilestoneId);
        dialogMilestoneSelector.show();
        dialogMilestoneLabel.show();
        
        dialogListName.val(todoListNameElement.html());
        dialogListDescription.val(todoListNameElement.attr("title"));
      },
      close: function() {
        dialogMilestoneSelector.val(app.TodoList.Dialog.find("[name='milestone_id']").val());
      }
    });

    app.TodoList.Dialog.dialog('open');
    dialogListName.focus();
    return false;
  });
  
  var _data = function(name, description, milestoneId) {
    return { _method: "PUT", todo_list: { 
      name: name, 
      description: description,
      milestone_id: milestoneId } };
  };
  
  var _postUpdate = function(todoList, name, description, newMilestoneId, oldMilestoneId) {
    app.spinner.dialog('open');
    
    $.post('/' + app.basecampAccountName + 
           '/todo_lists/' + app.TodoListMethods.todoListId(todoList), 
           _data(name, description, newMilestoneId), function() {
             app.spinner.dialog('close');
             if (!(keepTodoListWithDifferentMilestone) && (!oldMilestoneId && newMilestoneId) || (oldMilestoneId && oldMilestoneId != newMilestoneId)) {
               todoList.slideUp(1000);
             };
           });
  };
  
  var _updateName = function(todoList, todoListNameElement, dialogListName, dialogListDescription, dialogMilestoneSelector) {
    var oldName = todoListNameElement.html(),
        newName = dialogListName.val();
        oldDescription = todoListNameElement.attr("title");
        newDescription = dialogListDescription.val();
        oldMilestoneId = app.TodoList.Dialog.find("[name='milestone_id']").val();
        newMilestoneId = dialogMilestoneSelector.val(),
        milestoneTitleElement = todoList.find("span.milestone_title");
        milestoneTitleText = dialogMilestoneSelector[0].options[dialogMilestoneSelector[0].selectedIndex].text;
    // Content changed?
    if (oldName != newName || oldDescription != newDescription || oldMilestoneId != newMilestoneId) {
      _postUpdate(todoList, newName, newDescription, newMilestoneId, oldMilestoneId);
      todoListNameElement.text(newName);
      todoListNameElement.attr("title", newDescription);
      todoListNameElement.effect('pulsate', { times: 1 });
      
      if (milestoneTitleText == "None") {
        milestoneTitleText = "";
      }
      milestoneTitleElement.html(milestoneTitleText);
      milestoneTitleElement.attr("data-milestone-id", dialogMilestoneSelector.val());
    }
    app.TodoList.Dialog.dialog("close"); 
  };
  
};


// Adding a to-do list
app.TodoListMethods.newTodoListLinkBehavior = function(link, showMilestoneSelector) {
  link.click(function() {
    if (!app.TodoList.Dialog) return false;
    var form = app.TodoList.Dialog.find("form"),
    formMethod = form.find("input[name='_method']"),
    formName = app.TodoList.Dialog.find("#todo_list_name"),
    formDescription = form.find("#todo_list_description"),
    dialogListName = app.TodoList.Dialog.find("#todo_list_name"),
    dialogMilestoneLabel = app.TodoList.Dialog.find("label[for='todo_list_milestone']"),
    dialogMilestoneSelector = app.TodoList.Dialog.find("#todo_list_milestone_id");
    

    var submitButton = $('#todo_list_dialog_submit');
    submitButton.text("Create");

    submitButton.unbind(); // Prevent previous handlers on the shared button from being executed
    submitButton.click(function(event) {
      _submit(form, dialogListName);
      return false;
    });
    
    app.TodoList.Dialog.dialog('option', {
      title: 'New to-do list',
      open: function() {
        if ( !showMilestoneSelector ) {
          dialogMilestoneSelector.hide();
          dialogMilestoneLabel.hide();
        }
        
        form.attr('action', '/' + app.basecampAccountName + '/todo_lists');
        formMethod.val("post");
        formName.val("");
        formDescription.val("");
      }
    });
  
    app.TodoList.Dialog.dialog('open');
    dialogListName.focus();
    return false;
  });
  
  var _submit = function(form, dialogListName) {
    var name = dialogListName.val();
    if (name) {
      app.spinner.dialog('open');
      _postCreate(form);
    }
  };
  
  var _postCreate = function(form) {
    $.post(form.attr("action"), form.serialize(),
      function(response) {
        var response = response.todo_list; // rails returns => { todo_list: {} }
        app.spinner.dialog('close');
    
        var newToDoList = app.TodoList.Template.clone(),
            basecampLink = newToDoList.find("a.go_to_basecamp"),
            basecampLinkHref = basecampLink.attr("href"),
            newToDoListName = newToDoList.find("h3");
            milestoneTitleElement = newToDoList.find("span.milestone_title");
            dialogMilestoneSelector = app.TodoList.Dialog.find("#todo_list_milestone_id");
            milestoneTitleText = dialogMilestoneSelector[0].options[dialogMilestoneSelector[0].selectedIndex].text;
            
        
        basecampLink.attr("href", basecampLinkHref + response.id);
        newToDoList.attr("id", "todo_list_" + response.id);
        newToDoListName.text(response.name);
        newToDoListName.attr("title", response.description);
        if (milestoneTitleText == "None") {
          milestoneTitleText = "";
        } else {
          milestoneTitleElement.html(milestoneTitleText);
          milestoneTitleElement.attr("data-milestone-id", dialogMilestoneSelector.val());
        }
        
        $(".todo_list").first().before(newToDoList);
        newToDoList.slideDown('slow');
    
        // Apply sortable to columns of new list.
        // $(".col")sortable('refresh') does not work here, because the 
        // hidden app.TodoList.Template never got the sortable applied.
        // app.TodoListMethods.makeTodoItemsSortable(newToDoList.find(".col"));
    
        app.TodoList.Dialog.dialog('close'); 
      }
    );    
  };
  
};

app.TodoList = {};

$(function() {
  app.TodoList.Template = $("#template_todo_list");
});