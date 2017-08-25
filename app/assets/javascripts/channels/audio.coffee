play = (data) ->
  audio = new Audio(data.audio_id).play()

document.addEventListener 'turbolinks:load', (e) ->

  document.querySelectorAll('.audio-selection').forEach (elem) ->
    elem.addEventListener 'mouseup', (e) ->
      App.audio.play this.dataset.audioId

  App.audio = App.cable.subscriptions.create { channel:"AudioChannel", slug: App.slug },
    received: (data) ->
      switch data.action
        when 'play' then play data

    play: (audioID) ->
      @perform 'play', audio_id: audioID
