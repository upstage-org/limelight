# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@toggleShout = (e) ->
  input = $('#chat-speak')
  if $('#shoutToggle').is ':checked'
    input.val('!' + input.val()) unless input.val().indexOf('!') == 0
  else
    input.val(input.val().substring(1)) if input.val().indexOf('!') == 0
  return false
