// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the rails generate channel command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer();

  App.state = { avatars: [], drawings: [], backdrops: [], bubbles: [] };

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
        App.context.font="18px sans-serif";
        App.context.fillText(avatar.nickname, avatar.text_x, avatar.text_y);
      }
    });

    function drawBubble(x, y, width, height, radius, r, b, message, p){
      App.context.moveTo(x, y + 20 * p);
      App.context.lineTo(x - 10, y);
      App.context.lineTo(x - width - 10, y);
      App.context.quadraticCurveTo(x - width - radius - 10, y, x - width - radius - 10, y - radius * p);
      App.context.lineTo(x - width - 10 - radius, b);
      App.context.quadraticCurveTo(x - width - 10 - radius, b - radius * p, x - width - 10, b - radius * p);
      App.context.lineTo(r + 10, b - radius*p);
      App.context.quadraticCurveTo(r + radius + 10, b - radius * p, r + radius + 10, b);
      App.context.lineTo(r + radius + 10, y - radius * p);
      App.context.quadraticCurveTo(r + radius + 10, y, r + 10, y);
      App.context.lineTo(x + 10, y);
      App.context.lineTo(x, y + 20 * p);
      var i;
      for (i = 0; i < message.length; i++) {
        if(p < 0){
          App.context.fillText(message[i], x, y + 20 + i * 25);
        }
        else {
          App.context.fillText(message[i], x, y + 5 - height + i * 25);
        }
      }
    }

    function drawOval(x, y, radius, row, p) {
      App.context.save();
      App.context.translate(x, y - 14 * row * p);
      App.context.scale(2, 1);

      App.context.beginPath();
      App.context.arc(0, 0, radius, 0, 2 * Math.PI, false);
      App.context.restore();
      App.context.fillStyle = 'white';
      App.context.fill();
      App.context.lineWidth = 2;
      App.context.strokeStyle = 'blue';
      App.context.stroke();
    }

    App.state.bubbles.forEach(function(bubble){
      avatar = App.state.avatars[bubble.avatar_id];
      var x = avatar.x + avatar.width / 2;
      var y = avatar.y - 30;
      var width = 100;
      var height = 50;
      var r, b;
      var drawUp = 1;
      height = height + 25 * bubble.row;
      r = x + width;

      if(y - 10 - height < 0){
        y = avatar.y + avatar.height + 50;
        b = y + height;
        drawUp = -1;
      }
      else{
        b = y - height;
      }

      App.context.beginPath();
      if(bubble.type == "!"){
        App.context.strokeStyle = "red";
        App.context.lineWidth = "4";
        App.context.font = "bold 20px sans-serif";
        drawBubble(x, y, width, height, 20, r, b, bubble.txt, drawUp);
      }
      else if (bubble.type == ""){
        App.context.strokeStyle = "green";
        App.context.lineWidth = "2";
        App.context.font = "20px sans-serif";
        drawBubble(x, y, width, height, 20, r, b, bubble.txt, drawUp);
      }
      else if (bubble.type == ":") {
        drawOval(x, y - 55 * drawUp, 50 + 10 * bubble.row, bubble.row, drawUp);
        drawOval(x, y + 5 * drawUp + 10 * bubble.row * drawUp, 10, bubble.row, drawUp);
        drawOval(x, y + 20 * drawUp + 10 * bubble.row * drawUp, 5, bubble.row, drawUp);

        App.context.fillStyle = 'black';
        App.context.font = "20px sans-serif";
        if (drawUp > 0) {
          var i;
          for (i = 0; i < bubble.txt.length; i++) {
            App.context.fillText(bubble.txt[i], x, y - 70 - bubble.row * 30 + 30 * i);
          }
        }
        else {
          var i;
          for (i = 0; i < bubble.txt.length; i++) {
            App.context.fillText(bubble.txt[i], x, y + 45 + i * 30);
          }
        }
      }
      App.context.stroke();
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
    App.state = { avatars: [], drawings: [], backdrops: [], bubbles: [] };
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
