# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
init = () ->
	$('#reset_filters_btn').click ->
    $('#uploader').get(0).selectedIndex = 0;
    $('#type').get(0).selectedIndex = 0;
    $('#stage').get(0).selectedIndex = 0;
    $('#tag').get(0).selectedIndex = 0;
    $('#month').get(0).selectedIndex = 0;
    $('#year').get(0).selectedIndex = 0;
    $('form').submit()

$(document).on 'turbolinks:load', init
