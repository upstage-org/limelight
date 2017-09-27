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

    i = 0
    while i < 2
      next = next.next()
      if !next.length
        next = $(this).siblings(':first')
      next.children(':first-child').clone().appendTo $(this)
      i++
    return

$(document).on 'turbolinks:load', multiCarousel
