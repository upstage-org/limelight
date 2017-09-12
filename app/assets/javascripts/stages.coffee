# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

init = () ->
  $(document).on 'change', '#add_sound_path', (e) ->
    btn = $('#soundAssignmentButton')
    val = $(this).val()
    if val == ''
      btn.attr 'disabled', 'disabled'
      btn.data 'method', 'GET'
    else
      btn.removeAttr 'disabled'
      btn.data 'method', 'PATCH'
    btn.attr 'href', val
  $(document).on 'change', '#add_backdrop_path', (e) ->
    backdropbtn = $('#backdropAssignmentButton')
    backdropval = $(this).val()
    if backdropval == ''
      backdropbtn.attr 'disabled', 'disabled'
      backdropbtn.data 'method', 'GET'
    else
      backdropbtn.removeAttr 'disabled'
      backdropbtn.data 'method', 'PATCH'
    backdropbtn.attr 'href', backdropval

$(document).on 'turbolinks:load', init
