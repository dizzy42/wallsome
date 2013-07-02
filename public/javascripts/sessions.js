$(function() {
  // Show spinner if login takes a while
  $("#account").submit(function(){
    window.setTimeout("app.spinner.dialog('open')", 1000);
  });
});
