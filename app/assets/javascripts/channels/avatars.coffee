place = (data) ->
  value = '1'
  if App.state.avatars[data.avatar_id] != undefined  
    value = App.state.avatars[data.avatar_id].show
  img = new Image
  img.addEventListener 'load', (e) ->
    App.state.avatars[data.avatar_id] = {
      image: img,
      x: data['x'] - (img.width / 2),
      y: data['y'] - (img.height / 2),
      name: data['name'],
      text_x: data['x'],
      text_y: data['y'] + (img.height / 2) + 5,
      show: value
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
    nameBtn = document.querySelector '#avatarName'
    nameBtn.removeAttribute 'disabled', 'disabled'
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
    nameBtn = document.querySelector '#avatarName'
    nameBtn.removeAttribute 'disabled'
    window.holdWait = undefined
    window.holding = data.avatar_id
    
    mirrorDiv = document.querySelector '#mirrorPane'
    mirrorImg = new Image
    mirrorImg.addEventListener 'load', (e) ->
      mirrorDiv.appendChild(mirrorImg)
      mirrorDiv.removeChild(mirrorDiv.childNodes[0])
    mirrorImg.src = data['file']
    widthMultiplier = mirrorImg.width/mirrorImg.height
    mirrorImg.height = 80
    mirrorImg.width = 80*widthMultiplier

name = (data) ->
  avatar = App.state.avatars[data.avatar_id]
  if avatar.show == '1'
    avatar.image.title = '0'
  else 
    avatar.image.title = '1'
  App.state.avatars[data.avatar_id] = {
    image: avatar.image
    x: avatar.x
    y: avatar.y
    name: avatar.name
    text_x: avatar.text_x
    text_y: avatar.text_y
    show: avatar.image.title
  }
  App.drawFrame()

document.addEventListener 'turbolinks:load', (e) ->

  document.querySelectorAll('.avatar-selection').forEach (elem) ->
    elem.addEventListener 'mouseup', (e) ->
      App.avatar.hold this.dataset.avatarId

  document.querySelector('#dropAvatarButton').addEventListener 'mouseup', (e) ->
    App.avatar.drop()

  document.querySelector('#avatarName').addEventListener 'mouseup', (e) ->
    App.avatar.name()

  document.querySelector('#canvas').addEventListener 'mouseup', (e) ->
    App.avatar.place e.x, e.y

  App.avatar = App.cable.subscriptions.create { channel:"AvatarChannel", slug: App.slug },
    received: (data) ->
      switch data.action
        when 'hold' then hold data
        when 'drop' then drop data
        when 'name' then name data
        when 'place' then place data

    hold: (avatarId) ->
      window.holdWait = avatarId
      @perform 'hold', avatar_id: avatarId

    drop: () ->
      @perform 'drop', avatar_id: window.holding

    place: (x, y, name) ->
      @perform 'place', x: x, y: y, name: name, avatar_id: window.holding

    name: () ->
      @perform 'name', avatar_id: window.holding
