// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


function setFocus()
{
    // Sets the form focus to the first element found in forms[0] that
    // is a text field or text area.
    if (document.forms[0] == null) return;

    // Iterate though elements
    var e;
    for (var i = 0; i < document.forms[0].elements.length; i++)
    {
        e = document.forms[0].elements[i];
        if ((e.type == "text") || (e.type == "textarea"))
        {
            e.focus();
            break;
        }
    }
}
