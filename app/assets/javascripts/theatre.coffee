# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@toggleChatModifier = (sender) ->
  input = $('#chat-speak')
  checkbox = $(sender);
  if checkbox.is ':checked'
    input.val(checkbox.val() + input.val()) unless input.val().indexOf(checkbox.val()) == 0
  else
    input.val(input.val().substring(1)) if input.val().indexOf(checkbox.val()) == 0
  return false
