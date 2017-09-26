# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
multiCarousel = () ->
  $('#slider').carousel interval: false
  $('.carousel .item').each ->
    next = $(this).next()
    if !next.length
      next = $(this).siblings(':first')
    next.children(':first-child').clone().appendTo $(this)
    if next.next().length > 0
      next.next().children(':first-child').clone().appendTo $(this)
    else
      $(this).siblings(':first').children(':first-child').clone().appendTo $(this)
    return

$(document).on 'turbolinks:load', multiCarousel
