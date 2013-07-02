app.TodoItemMethods = {};
app.TodoItem = {};

app.TodoItemMethods.todoItemId = function(todoItem) {
  return todoItem.attr('id').slice(10);
};

app.TodoItemMethods.todoItemState = function(todoItem) {
  var col = todoItem.closest('.col');
  if (col.hasClass('open')) {
    return 'open';
  } else if (col.hasClass('in_progress')) {
    return 'in_progress';
  } else {
    return 'completed';
  }
};

app.TodoItemMethods.showHideActionLinks = function(todoItems) {
  todoItems.live('mouseenter', function() { $(this).find(".todo_item_actions").show(); });
  todoItems.live('mouseleave', function() { $(this).find(".todo_item_actions").hide(); });
};

app.TodoItemMethods.deleteTodoItemBehavior = function(links) {
  links.live('click', function() {
    var deleteButton = $(this);
    if (_shouldDelete()) {
      var todoItem = deleteButton.closest(".todo_item"),
          todoList = deleteButton.closest(".todo_list");
      _deleteTodoItem(todoList, todoItem);
    }
    deleteButton.blur();
    return false;
  });
  
  var _deleteTodoItem = function(todoList, todoItem) {
    todoItem.fadeOut('fast', function() {
      _postDelete(todoList, todoItem);
    });
  };
  
  var _postDelete = function(todoList, todoItem) {
    $.post('/' + app.basecampAccountName + 
           '/todo_lists/' + app.TodoListMethods.todoListId(todoList) + 
           '/todo_items/' + app.TodoItemMethods.todoItemId(todoItem), 
           { "_method": "delete" }, function() {
      todoItem.remove();
    });
  };
  
  var _shouldDelete = function() {
    var should = confirm("Delete to-do item?");
    return should;
  };
};
  
app.TodoItemMethods.editTodoItemBehavior = function(links) {
  links.live('click', function() {
    if (!app.TodoItem.Dialog) return false;
    
    var todoItem = $(this).closest(".todo_item"),
        todoItemContent = todoItem.find("p"),
        todoItemResponsibleParty = todoItem.find(".responsible_party"),
        form = app.TodoItem.Dialog.find("form"),
        formContent = app.TodoItem.Dialog.find("#todo_item_content");
        
    var submitButton = $('#todo_item_dialog_submit');
    submitButton.text("Update");

    submitButton.unbind(); // Prevent previous handlers on the shared button from being executed
    submitButton.click(function(event) {
      _submit(form, formContent, todoItemContent, todoItemResponsibleParty, todoItem);
      return false;
    });
    
    app.TodoItem.Dialog.dialog('option', {
      title: 'Edit to-do item',
      open: function() {
        _setupForm(form, formContent, todoItemResponsibleParty, todoItemContent, todoItem);
      }
    });

    app.TodoItem.Dialog.dialog('open');
    formContent.focus();
    return false;
  });
  
  var _submit = function(form, formContent, todoItemContent, todoItemResponsibleParty, todoItem) {
    var newContent = formContent.val(),
        formResponsibleParty = form.find("#todo_item_responsible_party"),
        newResponsiblePartyId = formResponsibleParty.find("option:selected").val();
        
    if (!newContent) {
      alert("Please enter a text for the to-do item.");
      formContent.focus();
      return false;
    }
    
    todoItemContent.text(newContent);
    todoItemResponsibleParty.attr("data-responsible-party-id", newResponsiblePartyId);
    todoItemResponsibleParty.text(app.responsiblePartyMap[newResponsiblePartyId]);
    
    $.post(form.attr("action"), form.serialize());
    
    if (('' + newResponsiblePartyId + '') == app.currentPersonId) {
      todoItem.addClass("responsible_for_item");
    } else {
      todoItem.removeClass("responsible_for_item");
    }
    todoItem.effect('pulsate', { times:1 });
    app.TodoItem.Dialog.dialog("close"); 
  };
  
  var _setupForm = function(form, formContent, todoItemResponsibleParty, todoItemContent, todoItem) {
    var todoList = todoItem.closest(".todo_list"),
        todoItemResponsiblePartyId = todoItemResponsibleParty.attr("data-responsible-party-id"),
        formMethod = form.find("input[name='_method']"),
        todoItemResponsibleParty = form.find("#todo_item_responsible_party");

    form.attr('action', '/' + app.basecampAccountName + 
                        '/todo_lists/' + app.TodoListMethods.todoListId(todoList) + 
                        '/todo_items/' + app.TodoItemMethods.todoItemId(todoItem));
    formMethod.val("put");
    if (!todoItemResponsiblePartyId) {
      form.find("option").removeAttr("selected");
      form.find("option:first").attr("selected", "selected");
    } else {
      todoItemResponsibleParty.val(todoItemResponsiblePartyId);
    }
    formContent.val(todoItemContent.text());
  };
  
};


$(function() {
  app.TodoItem.TemplateToDoItem = $("#template_todo_item");  
  
  app.TodoItemMethods.editTodoItemBehavior($(".edit_todo_item"));
  app.TodoItemMethods.deleteTodoItemBehavior($(".delete_todo_item"));
  app.TodoItemMethods.showHideActionLinks($(".todo_item"));

  app.Comments.enableForTodoItems($(".todo_item_comments"));
  
});