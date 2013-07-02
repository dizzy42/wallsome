app.Comments = {};

app.Comments.enableForTodoItems = function(links) {
  links.live('click', function() {
    var spinnerImage = $("#spinner_image"),
        form = app.Comments.Dialog.find("form");
    var todoItemId = app.TodoItemMethods.todoItemId($(this).closest(".todo_item"));
    app.Comments.Dialog.dialog('open');
    $.get('/' + app.basecampAccountName + '/todo_items/' + todoItemId + '/comments', 
          function(data) {
            $("#todo_item_comments").html(data);
          }
    );
    
    var submitButton = $('#comments_dialog_submit');

    submitButton.unbind(); // Prevent previous handlers on the shared button from being executed
    submitButton.click(function() {
      if ($("#comment_body").val().trim() != "") {
        spinnerImage.show();
        $.post('/' + app.basecampAccountName + '/todo_items/' + todoItemId + '/comments',
               form.serialize(),
               function(data) {
                 var list = app.Comments.Dialog.find("ul");
                 list.append(data);
                 $("#comment_body").val("");
                 spinnerImage.hide();
                 form.show();
                 $("body").find("#todo_item_" + todoItemId).find("a.comment_icon_link").show();
               }
        );
        form.hide();
      }
      return false;
    });
    return false;
  });
};
