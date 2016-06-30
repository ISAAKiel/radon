// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//

//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery-ui
//= require wice_grid
//= require_tree ../../../vendor/assets/javascripts/.
//= require openlayers-rails
//= require_tree .


function fill_hidden_field(source_field) {
  name_field = source_field.identify() + "_auto_complete"
  div_content = $(name_field).getElementsByClassName('selected')[0].identify();
  source_field.next('li').down(0).value=div_content;
}

$(function() {
  $('a[data-popup]').on('click', function(e) {
     window.open($(this).attr('href'), 'popup','toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, height=550, width=850');
     e.preventDefault();
  });
});

