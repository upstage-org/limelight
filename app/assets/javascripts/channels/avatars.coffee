place = (data) ->
  img = new Image
  img.addEventListener 'load', (e) ->
    App.state.avatars[data.avatar_id] = {
      image: img,
      x: data['x'] - (img.height / 2),
      y: data['y'] - (img.width / 2)
    }
    App.drawFrame()
  img.src = data['file']

drop = (data) ->
  btn = document.querySelector ".avatar-selection[data-avatar-id='#{data.avatar_id}']"
  btn.removeAttribute 'disabled'
  btn.setAttribute 'title', "#{btn.dataset.name}"
  delete App.state.avatars[data.avatar_id]
  App.drawFrame()
  if `data.avatar_id == window.holding`
    dropButton = document.querySelector '#dropAvatarButton'
    dropButton.setAttribute 'disabled', 'disabled'
    dropButton.removeAttribute 'title'
    dropButton.dataset.avatarId = undefined
    nameButton = document.querySelector '#avatarName'
    nameButton.setAttribute 'disabled', 'disabled'
    nameButton.removeAttribute 'title'
    nameButton.dataset.avatarId = undefined
    window.holding = undefined

hold = (data) ->
  btn = document.querySelector ".avatar-selection[data-avatar-id='#{data.avatar_id}']"
  btn.setAttribute 'disabled', 'disabled'
  btn.setAttribute 'title', "#{btn.getAttribute 'title'} (#{data.username})"
  if `data.avatar_id == window.holdWait`
    dropButton = document.querySelector '#dropAvatarButton'
    dropButton.removeAttribute 'disabled'
    dropButton.setAttribute 'title', "#{btn.dataset.name}"
    nameButton = document.querySelector '#avatarName'
    nameButton.removeAttribute 'disabled'
    nameButton.setAttribute 'title', "#{btn.dataset.name}"
    window.holdWait = undefined
    window.holding = data.avatar_id

name = (data) ->
  console.log("running name, data.avatar_name = " + data.avatar_name)


document.addEventListener 'turbolinks:load', (e) ->
  
  AvatarName = undefined

  document.querySelectorAll('.avatar-selection').forEach (elem) ->
    elem.addEventListener 'mouseup', (e) ->
      App.avatar.hold this.dataset.avatarId
      AvatarName = this.dataset.avatarName

  document.querySelector('#dropAvatarButton').addEventListener 'mouseup', (e) ->
    App.avatar.drop()
    console.log(this.dataset)

  document.querySelector('#canvas').addEventListener 'mouseup', (e) ->
    App.avatar.place e.x, e.y

  document.querySelector('#avatarName').addEventListener 'mouseup', (e) ->
    App.avatar.name AvatarName

  App.avatar = App.cable.subscriptions.create { channel:"AvatarChannel", slug: App.slug },
    received: (data) ->
      switch data.action
        when 'hold' then hold data
        when 'drop' then drop data
        when 'place' then place data
        when 'name' then name data.avatar_name

    hold: (avatarId) ->
      window.holdWait = avatarId
      @perform 'hold', avatar_id: avatarId

    drop: () ->
      @perform 'drop', avatar_id: window.holding

    place: (x, y) ->
      @perform 'place', x: x, y: y, avatar_id: window.holding

    name: (avatarName) ->
      @perform 'name', avatar_name: avatarName
