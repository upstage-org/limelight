# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.multi-item-carousel').carousel interval: false
# for every slide in carousel, copy the next slide's item in the slide.
# Do the same for the next, next item.
console.log($('#theCarousel').attr "images")
$('.multi-item-carousel .item').each ->
  console.log("Hello")
  console.log(this)
  next = $(this).next()
  if !next.length
    next = $(this).siblings(':first')
  next.children(':first-child').clone().appendTo $(this)
  if next.next().length > 0
    next.next().children(':first-child').clone().appendTo $(this)
  else
    $(this).siblings(':first').children(':first-child').clone().appendTo $(this)
  return
