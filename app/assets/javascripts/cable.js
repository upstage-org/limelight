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
      App.context.drawImage(backdrop.image, 0, 0, canvas.width,canvas.height);
    });

    // Draw avatars
    App.state.avatars.forEach(function(avatar) {
      App.context.drawImage(avatar.image, avatar.x, avatar.y, avatar.height, avatar.width);
    });

    // Draw drawings
    App.state.drawings.forEach(function(drawing) {
      App.context.lineWidth = drawing.size;
      App.context.strokeStyle = drawing.color;

      App.context.beginPath();

      App.context.moveTo(drawing.fromX, drawing.fromY);
      App.context.lineTo(drawing.toX, drawing.toY);

      App.context.stroke()
    });
  };

  App.resizeCanvas = function() {
    App.canvas.width = App.canvas.offsetWidth;
    App.canvas.height = App.canvas.offsetHeight;
    App.drawFrame();
  };

  document.addEventListener('turbolinks:load', function(e) {
    App.canvas = document.querySelector('#canvas');
    App.context = App.canvas.getContext('2d');
    App.slug = document.querySelector('meta[name="stage-slug"]').getAttribute('value');
    window.addEventListener('resize', App.resizeCanvas());
    App.resizeCanvas();
  });

}).call(this);
