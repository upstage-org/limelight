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

      speak: (content, stage_id, user_id, username) ->
        @perform 'speak', content: content, stage_id: stage_id, user_id: user_id, username: username

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
  App.global_chat.speak(
    content: ($("input:radio[name ='chat-modifier']:checked").val() || '') + $('#chat-speak').val(),
    stage_id: $('#stage-id').val(),
    user_id: $('#user-id').val(),
    username: $('#user-name').val()
  )
  if window.holding
    App.dialog.utter $('#chat-speak').val()
  $('#chat-speak').val('')


# When the user presses enter button while the chat input is focused, call the utter function
$(document).on 'keydown', '#chat-speak', (e) ->
  if e.keyCode == 13
    utter()
    e.target.value = ''
    e.preventDefault()
    return false

# When user clicks the 'Send' button in chat, call the utter function.
$(document).on 'mouseup', '#sendChat', (e) ->
  utter()
