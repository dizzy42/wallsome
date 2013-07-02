// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

app = {};

$(function() {

  // Define a single global variable to register objects that should be 
  // available application-wide
  
  // The modal dialog for showing the spinner image
  app.spinner = $('#spinner').dialog({
    autoOpen: false,
    modal: true,
    resizable: false,
    draggable: false
  });
  
  app.dataEntryDialog = $('#dialog').dialog({ 
    autoOpen: false,
    modal: true,
    resizable: false
  });

  // Make spinner always go away on unload, so it's hidden again e.g. on back-button click
  $(window).unload(function() {
    app.spinner.dialog('close');
  });
  
  $("a.spinner").click(function() {
    app.spinner.dialog('open');
  });
});
