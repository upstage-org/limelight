jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')
  if $('#messages').length > 0

    # set scroll bar to the very bottom of the body so that users can see the newest message instantly
    messages_to_bottom = -> $('#chat-body').scrollTop($('#chat-body').prop("scrollHeight"))

    messages_to_bottom()

    doc = $(document)
    canvas = $('#canvas')
    context = canvas[0].getContext('2d')
    prev = {}
    colour = 'black'
    drawing = false
    timeSinceLastSend = $.now()
    size = 1
    dragging = false

    $('.color-option').click  ->
      color = $(this).data("color")
      if color == 'pink'
        console.log('pink')
        colour = 'pink'
      else if color == 'red'
        colour = '#ff0000'
        console.log('red')
      else if color == 'blue'
        colour = 'blue'
        console.log('blue')
      else if color == 'green'
        colour = 'green'
      else if color == 'black'
        colour = 'black'
      else if color == 'white'
        colour = 'white'
      else if color == 'clear'
        console.log("CLEAR")
        $.ajax
          method: "POST",
          url: "/updatedrawing",
          data:
            'drawing_option': 'clear'
            'stage_id': $('#stage-id').val()

    $('.size-option').click ->
      size_option = $(this).data("size")

      if size_option == 'increase'
        if size <= 11
          size += 5
          document.getElementById("brushSize").innerHTML = size
      else
        if size > 5
          size -= 5
          document.getElementById("brushSize").innerHTML = size

    canvas.on 'mousedown touchstart', (e) ->
      if $("#avatar").hasClass('active')
        if(window.holding != undefined)
          avatar = App.state.avatars[window.holding]
          if(avatar != undefined)
            if(e.clientX >= avatar.x && e.clientX <= (avatar.width + avatar.x))
              if(e.clientY >= avatar.y && e.clientY <= (avatar.height + avatar.y))
                dragging = true

      e.preventDefault()
      x = e.offsetX
      y = e.offsetY

      if e.originalEvent.changedTouches
        e = e.originalEvent.changedTouches[0]
        x = e.offsetX
        y = e.offsetY

      if $("#drawing").hasClass('active')
        drawing = true
      prev.x = x
      prev.y = y

    canvas.bind 'mouseup mouseleave touchend', ->
      drawing = false
      dragging = false

    canvas.on 'mousemove touchmove', (e) ->
      if(dragging)
        avatar = App.state.avatars[window.holding]
        img = new Image()
        img.onload = ->
          context.clearRect(0, 0, innerWidth, innerHeight);
          App.drawFrame()
          context.globalAlpha = 0.4
          x = e.clientX - (avatar.width / 2)
          y = e.clientY - (avatar.height / 2)
          context.drawImage(img, x, y, avatar.width, avatar.height)
          context.globalAlpha = 1.0
        img.src = avatar.image.src
      else if(drawing && $.now() - timeSinceLastSend > 10)
        x = e.offsetX
        y = e.offsetY
        stage_id = $('#stage-id').val()

        if(e.originalEvent.changedTouches)
          e = e.originalEvent.changedTouches[0]
          x = e.offsetX; y = e.offsetY;

        # send the data to theatre controller (see config/routes.rb)
        $.ajax
          method: "POST",
          url: "/updatedrawing",
          data:
            'drawing_option': 'draw'
            'fromx': prev.x,
            'fromy': prev.y,
            'tox': x,
            'toy': y,
            'colour': colour,
            'size': size,
            'stage_id': stage_id

        timeSinceLastSend = $.now()

        if (drawing && x && y)
          drawLine(prev.x, prev.y, x, y, colour, size)
          prev.x = x
          prev.y = y

    drawLine = (fromx, fromy, tox, toy, colour, size) ->
      context.lineWidth = size
      context.strokeStyle = colour
      context.beginPath()
      context.moveTo(fromx, fromy)
      context.lineTo(tox, toy)
      context.stroke()
      return false;

    ################## BACKDROP #####################################################
    images = document.getElementsByClassName("backdrops")

    for i in images
      do (i) ->
        i.addEventListener "click", ->
          name = i.id
          filename = $("#" + name).data("backdrop-filename")
          document.body.style.backgroundImage = 'url("/uploads/' + filename + '")'

    ###################################### ACTIONCABLES##################################
    App.global_chat = App.cable.subscriptions.create { channel:"ChatChannel", stage: messages.data('stage-id') },
      connected: ->
        # Called when the subscription is ready for use on the server
        nick = $('#user-name').val()

        if nick != null
          console.log(nick)
          $('.user_list').append("<li>" + nick + "</li>")
        else
          console.log(nick)
          $('.user_list').append("<li>Guest</li>")


      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        # Called when there's incoming data on the websocket for this channel
        $messages = $('#messages')
        $messages.append(data)
        messages_to_bottom()

      speak: (content, stage_id, user_id, username, avatarName) ->
        @perform 'speak', content: content, stage_id: stage_id, user_id: user_id, username: username, avatarName: avatarName

    # ActionCable for Drawing
    App.global_draw = App.cable.subscriptions.create { channel:"DrawingChannel", stage: messages.data('stage-id') },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        # Called when there's incoming data on the websocket for this channel
        if data.drawing_option == 'draw'
          App.state.drawings.push {
            fromX: data.fromx,
            fromY: data.fromy,
            toX: data.tox,
            toY: data.toy,
            color: data.colour,
            size: data.size
          }
          App.drawFrame()

    #ActionCable for updating list of users in the stage
    App.userlist = App.cable.subscriptions.create { channel:"UserChannel", stage: messages.data('stage-id') },
      connected: ->
        # ActionCable.server.broadcast "userlist_channel#{messages.data('stage-id')}",
      disconnected: ->
        # ActionCable.server.broadcast "audio_channel#{messages.data('stage-id')}",
      received: (data) ->

# Sends the chat message through the websocket
utter = () ->
  avatarName = ""
  if window.holding
    avatarName = App.state.avatars[window.holding].nickname
  App.global_chat.speak(
    content: ($("input:radio[name ='chat-modifier']:checked").val() || '') + $('#chat-speak').val(),
    stage_id: $('#stage-id').val(),
    user_id: $('#user-id').val(),
    username: $('#user-name').val()
    avatarName: avatarName
  )
  if window.holding
    m = $("input:radio[name ='chat-modifier']:checked").val()
    if m == '!'
      shoutBubble($('#chat-speak').val().toUpperCase())
      setTimeout (->
        App.drawFrame()
        return
      ), 3000
    else if m == ''
      speechBubble($('#chat-speak').val())
      setTimeout (->
        App.drawFrame()
        return
      ), 3000
    App.dialog.utter $('#chat-speak').val()
  $('#chat-speak').val('')


# When the user presses enter button while the chat input is focused, call the utter function
$(document).on 'keydown', '#chat-speak', (e) ->
  if e.keyCode == 13
    utter()
    e.target.value = ''
    e.preventDefault()
    return false

shoutBubble = (txt) ->
  avatar = App.state.avatars[window.holding]
  height = 60
  width = 160
  x = avatar.x + avatar.width/2 - width / 2
  y = avatar.y - 30
  spike = 20

  App.context.beginPath()
  App.context.strokeStyle = "red"
  App.context.lineWidth = "4"
  App.context.moveTo(x,y)

  i = 0
  while i < height/spike
    App.context.lineTo(x-spike, y-i*spike-spike/2)
    App.context.lineTo(x, y-i*spike-spike)
    i++

  i = 0
  while i < width/spike
    App.context.lineTo(x+i*spike+spike/2, y-height-spike)
    App.context.lineTo(x+i*spike+spike, y-height)
    i++

  i = 0
  while i < height/spike
    App.context.lineTo(x+width+spike, y+i*spike-height+spike/2)
    App.context.lineTo(x+width, y+i*spike-height+spike)
    i++

  i = 0
  while i < width/spike
    App.context.lineTo(x+width-i*spike-spike/2, y+spike)
    App.context.lineTo(x+width-i*spike-spike, y)
    i++

  App.context.fillStyle = "white"
  App.context.fill()
  App.context.fillStyle = "black"
  App.context.font = "20px sans-serif"
  App.context.textAlign = "center"
  App.context.fillText(txt, avatar.x + avatar.width/2 , y-45)
  App.context.stroke()

speechBubble = (txt) ->
  avatar = App.state.avatars[window.holding]
  x = avatar.x + avatar.width/2
  y = avatar.y - 30
  width = 100
  height = 50
  radius = 20
  lines = []

  if txt.length > 17
    height = height + 25*(parseInt(txt.length / 17))
    lines = txt.split(' ')

  r = x + width
  b = y - height
  App.context.beginPath()
  App.context.strokeStyle = "green"
  App.context.lineWidth = "2"
  App.context.moveTo(x, y + 20)
  App.context.lineTo(x - 10, y)
  App.context.lineTo(x - width - 10, y)
  App.context.quadraticCurveTo(x - width - radius - 10, y, x - width - radius - 10, y - radius)
  App.context.lineTo(x - width - 10 - radius, b)
  App.context.quadraticCurveTo(x - width - 10 - radius, b - radius, x - width - 10, b - radius)
  App.context.lineTo(r + 10, b - radius)
  App.context.quadraticCurveTo(r + radius + 10, b - radius, r + radius + 10, b)
  App.context.lineTo(r + radius + 10, y - radius)
  App.context.quadraticCurveTo(r + radius + 10, y, r + 10, y)
  App.context.lineTo(x + 10, y)
  App.context.lineTo(x, y + 20)
  App.context.fillStyle = "white"
  App.context.fill()
  App.context.fillStyle = "black"
  App.context.font = "20px sans-serif"
  App.context.textAlign = "center"

  if lines.length > 0
    i = 0
    line = ""
    count = 0
    row = 0
    while i < lines.length
      if lines[i].length + count <= 17
        count += lines[i].length
        line = line + lines[i] + " "
      else
        App.context.fillText(line, x, y-height+row*25)
        row++
        count = lines[i].length
        line = lines[i] + " "
      if i == lines.length - 1
        App.context.fillText(line, x, y-height+row*25)
      i++
  else
    App.context.fillText(txt, x, y-height)
  App.context.stroke()

# When user clicks the 'Send' button in chat, call the utter function.
$(document).on 'mouseup', '#sendChat', (e) ->
  utter()
