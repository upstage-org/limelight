# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@initHTMLTextArea = () ->
  $('textarea').each (i, elem) ->
    $(elem).wysihtml5()

$(document).on 'turbolinks:load', initHTMLTextArea
