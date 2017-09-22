show = (data) ->
  # console.log("---------------")
  backdrop = new Backdrop(data.backdrop_id).show()

  App.state.backdrops[data.backdrop_id] = {
    image: backdrop
  }
  App.drawFrame();


document.addEventListener 'turbolinks:load', (e) ->
  document.querySelectorAll('.backdrop-selection').forEach (elem) ->
      elem.addEventListener 'mouseup', (e) ->
        App.backdrop.show this.dataset.backdropId

    App.backdrop = App.cable.subscriptions.create {
      channel:"BackdropChannel", slug: App.slug },
        received: (data) ->
          switch data.action
            when 'show' then show data

        show: (backdropId) ->
          @perform 'show', backdrop_id: backdropId
