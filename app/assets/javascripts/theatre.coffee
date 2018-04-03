# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
init = () ->
  slickSlider()
  rangeSlider()
  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    $('.scroller').slick('setPosition');

slickSlider = () ->
  $('.scroller').slick({
    dots: true
    infinite: false
    slidesToShow: 6
    slidesToScroll: 6
  })

rangeSlider = () ->
  slider = $('.range-slider')
  range = $('.range-slider-range')
  value = $('.range-slider-value')

  range.on 'input', ->
    $(this).next(value).html @value

$(document).on 'turbolinks:load', init
