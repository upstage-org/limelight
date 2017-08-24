play = (data) ->
  console.log(data)
  audio = new Audio(data.audio_id).play()

document.addEventListener 'turbolinks:load', (e) ->

  document.querySelectorAll('.audio-selection').forEach (elem) ->
    elem.addEventListener 'mouseup', (e) ->
      App.audio.play this.dataset.audioID
      console.log("3 ")

  App.audio = App.cable.subscriptions.create { channel:"AudioChannel", slug: App.slug },
    received: (data) ->
      switch data.action
        when 'play' then play data
      console.log("1 " + data.audio_id)

    play: (audioID) ->
      @perform 'play', audio_id: audioID

