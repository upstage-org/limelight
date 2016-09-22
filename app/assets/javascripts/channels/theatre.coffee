jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')
  if $('#messages').length > 0

    messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

    messages_to_bottom()
    
    App.global_chat = App.cable.subscriptions.create { channel:"TheatreChannel", stage: messages.data('stage-id') },
      connected: ->
        # Called when the subscription is ready for use on the server
        
    
      disconnected: ->
        # Called when the subscription has been terminated by the server
    
      received: (data) ->
        # Called when there's incoming data on the websocket for this channel
        $messages = $('#messages')
        $messages.append(data)
        $('#chat').scrollTop($('#chat').prop("scrollHeight"));
    
      speak: (content, stage_id, user_id, username) ->
        @perform 'speak', content: content, stage_id: stage_id, user_id: user_id, username: username
        
    
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