# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
backdropSlick = () ->
  $('.scroller').slick({
    dots: true
    infinite: false
    slidesToShow: 4
    slidesToScroll: 4
  })

$(document).on 'turbolinks:load', backdropSlick
