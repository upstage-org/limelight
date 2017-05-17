# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

init = () ->
  $(document).on 'change', '#add_sound_path', (e) ->
    $('#assignSoundButton').removeAttr 'disabled' if $(this).val() != ''
    $('#assignSoundButton').attr 'disabled', 'disabled' if $(this).val() == ''
    $('#assignSoundButton').attr 'href', $(this).val()

$(document).on 'turbolinks:load', init
