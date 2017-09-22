display = (data) ->
  backdrop = new Backdrop(data.backdrop_id).display()

  App.state.backdrops[data.backdrop_id] = {
    image: backdrop
  }
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
