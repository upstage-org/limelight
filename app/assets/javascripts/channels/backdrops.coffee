display = (data) ->
  # delete App.state.backdrops
  backdrop = new Image(data.backdrop_id)
  backdrop.src = data['file']
  unless App.state.backdrops.length or App.state.backdrops[data.backdrop_id] in App.state.backdrops
    App.state.backdrops[data.backdrop_id] = {
      image: backdrop
    }
  else
    App.state.backdrops = []

  # console.log(backdrop)
  App.drawFrame();


document.addEventListener 'turbolinks:load', (e) ->
  document.querySelectorAll('.backdrop-selection').forEach (elem) ->
      elem.addEventListener 'mouseup', (e) ->
        App.backdrop.display this.dataset.backdropId

  App.backdrop = App.cable.subscriptions.create {
    channel:"BackdropChannel", slug: App.slug },
      received: (data) ->
        switch data.action
          when 'display' then display data

      display: (backdropId) ->
        @perform 'display', backdrop_id: backdropId
