$( document ).ready(function() {

  $('#slider').carousel({
    interval: 0
  })

  $('.carousel .item').each(function(){
    var next = $(this).next();
    if (!next.length) {
      next = $(this).siblings(':first');
    }
    next.children(':first-child').clone().appendTo($(this));

    if (next.next().length>0) {
      next.next().children(':first-child').clone().appendTo($(this));
    }
    else {
      $(this).siblings(':first').children(':first-child').clone().appendTo($(this));
    }
  });

  // $(".carousel-inner .item img").on ("click", function(){
  //   console.log(this)
  //   App.context.clearRect(0, 0, App.canvas.width, App.canvas.height);
  //   // var canvas = document.getElementById("canvas");
  //   console.log(canvas)
  //   App.context.drawImage(this,0,0);
  //   App.cable.drawFrame();
  // });

});

// init = () ->
  // $(document).on 'click', 'img', (e) ->
  //   console.log(1)
//
// $(document).on 'turbolinks:load', init
