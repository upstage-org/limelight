// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the rails generate channel command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer();

  App.state = { avatars: [], drawings: [], backdrops: [] };

  App.drawFrame = function() {
    // Clear frame

    App.context.clearRect(0, 0, canvas.width, canvas.height);

    // Draw backdrop
    App.state.backdrops.forEach(function(backdrop){
      var ratio;
      if(backdrop.image.naturalHeight >= backdrop.image.naturalWidth){
        if(canvas.width * backdrop.image.naturalHeight / backdrop.image.naturalWidth > canvas.height){
          ratio = canvas.height/backdrop.image.naturalHeight;
        } else {
          ratio = canvas.width/backdrop.image.naturalWidth;
        }
      } else {
        if(canvas.height * backdrop.image.naturalWidth / backdrop.image.naturalHeight > canvas.width){
          ratio = canvas.width/backdrop.image.naturalWidth;
        } else {
          ratio = canvas.height/backdrop.image.naturalHeight;
        }
      }
      var newHeight = backdrop.image.naturalHeight * ratio;
      var newWidth = backdrop.image.naturalWidth * ratio;
      var startingX = (canvas.width - newWidth) / 2;
      var startingY = (canvas.height - newHeight) / 2;

      App.context.drawImage(backdrop.image, 0, 0, backdrop.image.naturalWidth, backdrop.image.naturalHeight,
                            startingX, startingY, newWidth, newHeight);
    });

    // Draw avatars
    App.state.avatars.forEach(function(avatar) {
      App.context.drawImage(avatar.image, avatar.x, avatar.y, avatar.width, avatar.height);
      App.context.textAlign = "center";
      App.context.textBaseline = "top";
      if(avatar.show == '1'){
        App.context.fillText(avatar.nickname, avatar.text_x, avatar.text_y);
      }
    });

    // Draw drawings
    App.state.drawings.forEach(function(drawing) {
      App.context.lineWidth = drawing.size;
      App.context.strokeStyle = drawing.color;

      App.context.beginPath();

      App.context.moveTo(drawing.fromX, drawing.fromY);
      App.context.lineTo(drawing.toX, drawing.toY);

      App.context.stroke();
    });
  };

  App.resizeCanvas = function() {
    App.canvas.width = App.canvas.offsetWidth;
    App.canvas.height = App.canvas.offsetHeight;
    App.drawFrame();
  };

  function clearState() {
    if(App.avatar)
      App.avatar.drop();
    App.avatar = undefined;
    window.holding = undefined;
    App.state = { avatars: [], drawings: [], backdrops: [] };
  }

  document.addEventListener('turbolinks:load', function(e) {
    clearState();
    App.canvas = document.querySelector('#canvas');
    if(App.canvas){
      App.context = App.canvas.getContext('2d');
      App.slug = document.querySelector('meta[name="stage-slug"]').getAttribute('value');
      window.addEventListener('resize', App.resizeCanvas);
      App.resizeCanvas();
    }
  });

}).call(this);
