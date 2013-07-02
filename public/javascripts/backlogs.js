$(function() {
  $(".filter").change(function(){
    $(this).closest('form').submit();
    // Show spinner while filtering a backlog
    app.spinner.dialog('open');
  });
});
