$(function() {
  // Show spinner while loading a wall for a milestone
  $(".milestone_title a").click(function(){
    app.spinner.dialog('open');
  });
  
  // Show spinner while loading a backlog
  $("a.backlog").click(function(){
    app.spinner.dialog('open');
  });
  
});
