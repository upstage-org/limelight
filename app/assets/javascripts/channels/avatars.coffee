place = (data) ->
  img = new Image
  img.addEventListener 'load', (e) ->
    App.state.avatars[data.avatar_id] = {
      image: img,
      x: data['x'] - (img.height / 2),
      y: data['y'] - (img.width / 2),
      height: img.height,
      width: img.width
    }
    App.drawFrame()
  img.src = data['file']
  multiplier = data.value/10
  img.height = img.height*multiplier
  img.width = img.width*multiplier

size = (data) ->
  backdropObj = App.state.avatars[data.avatar_id]
  backdropTag = App.state.avatars[data.avatar_id].image
  multiplier = data.value/10
  backdropTag.height = backdropTag.height*multiplier
  backdropTag.width = backdropTag.width*multiplier
  App.state.avatars[data.avatar_id] = {
    image: backdropTag,
    x: backdropObj.x,
    y: backdropObj.y,
    height: backdropTag.height,
    width: backdropTag.width
  }
  App.drawFrame()

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
    window.holding = undefined

    mirrorDiv = document.querySelector '#mirrorPane'
    mirrorDiv.innerHTML = ' '

hold = (data) ->
  btn = document.querySelector ".avatar-selection[data-avatar-id='#{data.avatar_id}']"
  btn.setAttribute 'disabled', 'disabled'
  btn.setAttribute 'title', "#{btn.getAttribute 'title'} (#{data.username})"
  if `data.avatar_id == window.holdWait`
    dropButton = document.querySelector '#dropAvatarButton'
    dropButton.removeAttribute 'disabled'
    dropButton.setAttribute 'title', "#{btn.dataset.name}"
    window.holdWait = undefined
    window.holding = data.avatar_id

    mirrorDiv = document.querySelector '#mirrorPane'
    mirrorImg = new Image
    mirrorImg.height = 100
    mirrorImg.width = 100
    mirrorImg.addEventListener 'load', (e) ->
      mirrorDiv.appendChild(mirrorImg)
      mirrorDiv.removeChild(mirrorDiv.childNodes[0])
    mirrorImg.src = data['file']

document.addEventListener 'turbolinks:load', (e) ->

  document.querySelectorAll('.avatar-selection').forEach (elem) ->
    elem.addEventListener 'mouseup', (e) ->
      App.avatar.hold this.dataset.avatarId

  document.querySelector('#avatarSlider').addEventListener 'mouseup', (e) ->
    App.avatar.size document.querySelector('#avatarSlider').value


  document.querySelector('#dropAvatarButton').addEventListener 'mouseup', (e) ->
    App.avatar.drop()

  document.querySelector('#canvas').addEventListener 'mouseup', (e) ->
    App.avatar.place e.x, e.y, document.querySelector('#avatarSlider').value

  App.avatar = App.cable.subscriptions.create { channel:"AvatarChannel", slug: App.slug },
    received: (data) ->
      switch data.action
        when 'hold' then hold data
        when 'size' then size data
        when 'drop' then drop data
        when 'place' then place data

    hold: (avatarId) ->
      window.holdWait = avatarId
      @perform 'hold', avatar_id: avatarId

    size: (value) ->
      if window.holding != undefined
        @perform 'size', avatar_id: window.holding, value: value

    drop: () ->
      @perform 'drop', avatar_id: window.holding

    place: (x, y, value) ->
      @perform 'place', x: x, y: y, value: value, avatar_id: window.holding
