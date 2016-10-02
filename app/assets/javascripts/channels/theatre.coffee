jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')
  if $('#messages').length > 0

    messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

    messages_to_bottom()
    
    
    
    doc = $(document)
    canvas = $('#canvas')
    context = canvas[0].getContext('2d')
    prev = {}
    colour = 'black'
    drawing = false
    timeSinceLastSend = $.now()
    size = 1
    
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
    
                
    doc.bind 'mouseup mouseleave touchend', ->
      drawing = false
               
    
    doc.on 'mousemove touchmove', (e) ->
      if(drawing && $.now() - timeSinceLastSend > 10) 
        x = e.offsetX
        y = e.offsetY
        stage_id = $('#stage-id').val()
                        
        if(e.originalEvent.changedTouches) 
          e = e.originalEvent.changedTouches[0]
          x = e.offsetX; y = e.offsetY;
      
                        
        $.ajax
          method: "POST",
          url: "/updatedrawing",
          data: 
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
      context.beginPath()
      context.lineWidth = size
      context.strokeStyle = colour
      context.moveTo(fromx, fromy)
      context.lineTo(tox, toy)
      context.stroke()
      return false;
    
    
    
    audio = document.getElementsByClassName("audio-option")
    
    for i in audio
      do (i) ->
        i.addEventListener "ended", ->
          name = i.id
          $("." + name).data('audio-mode', "play")
          $("." + name).text("play")
          console.log("ended " + name)
        i.addEventListener "play", ->
          name = i.id
          $("." + name).data('audio-mode', "pause")
          $("." + name).text("pause")
        i.addEventListener "pause", ->
          name = i.id
          $("." + name).data('audio-mode', "play")
          $("." + name).text("play")
   
    $('.audio-button').click  ->
      audio_name = $(this).data('audio-name')
      play_mode = $(this).data('audio-mode')
      console.log($(this).data('audio-name'))
      $.ajax
        method: "POST",
        url: "/updateaudio",
        data: 
          'audio_name': audio_name,
          'play_mode': play_mode,
          'stage_id': messages.data('stage-id')
      
      # if($("." + audio_name).data('audio-mode') == 'play')   
      #   $("." + audio_name).text("pause")
      #   $("." + audio_name).data('audio-mode', "pause")
      # else 
      #   $("." + audio_name).text("play")
      #   $("." + audio_name).data('audio-mode', "play")
      
      
    audioControl = (audio_name, play_mode) ->
      console.log("audio control method " + audio_name + " " + play_mode)
      # if(play_mode == 'play')   
      #   $("." + audio_name).text("pause")
      #   $("." + audio_name).data('audio-mode', "pause")
      # else 
      #   $("." + audio_name).text("play")
      #   $("." + audio_name).data('audio-mode', "play")
      audio_id = "#" + audio_name
      $(audio_id).trigger(play_mode)

      
            
    App.global_chat = App.cable.subscriptions.create { channel:"ChatChannel", stage: messages.data('stage-id') },
      connected: ->
        # Called when the subscription is ready for use on the server
        
      disconnected: ->
        # Called when the subscription has been terminated by the server
    
      received: (data) ->
        # Called when there's incoming data on the websocket for this channel
        $messages = $('#messages')
        $messages.append(data)
        $('#chat').scrollTop($('#chat').prop("scrollHeight"))
    
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
        drawLine(data.fromx, data.fromy, data.tox, data.toy, data.colour, data.size)
   
    #ActionCable for audio
    App.global_audio = App.cable.subscriptions.create { channel:"AudioChannel", stage: messages.data('stage-id') },
      connected: ->
        
      disconnected: ->
        
      received: (data) ->
        audioControl(data.audio_name, data.play_mode)
        
    #ActionCable for avatar
    App.global_avatar = App.cable.subscriptions.create { channel:"AvatarChannel", stage: messages.data('stage-id') },
      connected: ->
      disconnected: ->
      received: (data) ->
      
        
$(document).on 'keydown', '#chat-speak', (e) ->
  if e.keyCode == 13
    App.global_chat.speak( 
      content: $('#chat-speak').val(), 
      stage_id: $('#stage-id').val(),
      user_id: $('#user-id').val(),
      username: $('#user-name').val()
      )
    e.target.value = ''
    e.preventDefault()
    return false
    
 
    
