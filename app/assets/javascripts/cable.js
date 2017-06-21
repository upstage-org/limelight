// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the rails generate channel command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer();

  App.state = { avatars: [] };

  App.drawFrame = function() {
    var canvas = document.querySelector('#canvas');
    var ctx = canvas.getContext('2d');
    // Clear frame
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    // Draw avatars
    App.state.avatars.forEach(function(avatar) {
      ctx.drawImage(avatar.image, avatar.x, avatar.y);
    });
  };

}).call(this);
