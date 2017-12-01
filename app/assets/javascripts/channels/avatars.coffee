avatarName = {}

place = (data) ->
  img = new Image
  img.src = data['file']
  multiplier = data.size/10
  img.height = img.height*multiplier
  img.width = img.width*multiplier
  displayName = '1'
  if App.state.avatars[data.avatar_id] != undefined
    displayName = App.state.avatars[data.avatar_id].show
  img.addEventListener 'load', (e) ->
    App.state.avatars[data.avatar_id] = {
      image: img,
      x: data['x'] - (img.width / 2),
      y: data['y'] - (img.height / 2),
      height: img.height,
      width: img.width,
      text_x: data['x'],
      text_y: data['y'] + (img.height / 2) + 5,
      show: displayName,
      nickname: avatarName[data.avatar_id]
    }
    App.drawFrame()

size = (data) ->
  if App.state.avatars[data.avatar_id] != undefined
    img = new Image
    resize = App.state.avatars[data.avatar_id]
    img.src = data['file']
    multiplier = data.value/10
    resize.image.height = img.height*multiplier
    resize.image.width = img.width*multiplier
    App.state.avatars[data.avatar_id] = {
      image: resize.image,
      x: resize.x,
      y: resize.y,
      height: resize.image.height,
      width: resize.image.width,
      text_x: resize.x + (resize.image.width / 2),
      text_y: resize.y + resize.image.height + 5,
      show: resize.show
      nickname: avatarName[data.avatar_id]
    }
    App.drawFrame()

drop = (data) ->
  btn = document.querySelector ".avatar-selection[data-avatar-id='#{data.avatar_id}']"
  btn.removeAttribute 'disabled'
  btn.setAttribute 'title', "#{btn.dataset.name}"
  delete App.state.avatars[data.avatar_id]
  App.drawFrame()
  if `data.avatar_id == window.holding`
    nameInput = document.querySelector '#editAvatarName'
    nameInput.removeAttribute 'value'
    nameInput.setAttribute 'disabled', 'disabled'
    editNameBtn = document.querySelector '#editNameBtn'
    editNameBtn.setAttribute 'disabled', 'disabled'
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
  if avatarName[data.avatar_id] == undefined
    avatarName[data.avatar_id] = data['name']
  if `data.avatar_id == window.holdWait`
    nameInput = document.querySelector '#editAvatarName'
    nameInput.value = avatarName[data.avatar_id]
    nameInput.removeAttribute 'disabled'
    editBtn = document.querySelector '#editNameBtn'
    editBtn.removeAttribute 'disabled'
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

nameToggle = (data) ->
  avatar = App.state.avatars[data.avatar_id]
  nameShow = '1'
  if avatar.show == '1'
    nameShow = '0'
  else
    nameShow = '1'
  App.state.avatars[data.avatar_id] = {
    image: avatar.image,
    x: avatar.x,
    y: avatar.y,
    height: avatar.image.height,
    width: avatar.image.width,
    text_x: avatar.text_x,
    text_y: avatar.text_y,
    show: nameShow
    nickname: avatarName[data.avatar_id]
  }
  App.drawFrame()

editName = (data) ->
  nameInput = document.querySelector '#editAvatarName'
  avatarName[data.avatar_id] = nameInput.value
  avatar = App.state.avatars[data.avatar_id]
  App.state.avatars[data.avatar_id] = {
    image: avatar.image,
    x: avatar.x,
    y: avatar.y,
    height: avatar.image.height,
    width: avatar.image.width,
    text_x: avatar.text_x,
    text_y: avatar.text_y,
    show: avatar.show
    nickname: avatarName[data.avatar_id]
  }
  App.drawFrame()

document.addEventListener 'turbolinks:load', (e) ->

  document.querySelectorAll('.avatar-selection').forEach (elem) ->
    elem.addEventListener 'mouseup', (e) ->
      App.avatar.hold this.dataset.avatarId, this.dataset.avatarName

  document.querySelector('#avatarSlider').addEventListener 'change', (e) ->
    App.avatar.size document.querySelector('#avatarSlider').value

  document.querySelector('#dropAvatarButton').addEventListener 'mouseup', (e) ->
    App.avatar.drop()

  document.querySelector('#editNameBtn').addEventListener 'mouseup', (e) ->
    App.avatar.editName()

  document.querySelector('#avatarName').addEventListener 'mouseup', (e) ->
    App.avatar.nameToggle()

  document.querySelector('#canvas').addEventListener 'mouseup', (e) ->
    App.avatar.place e.x, e.y, document.querySelector('#avatarSlider').value, document.querySelector('.avatar-selection').avatarName

  App.avatar = App.cable.subscriptions.create { channel:"AvatarChannel", slug: App.slug },
    received: (data) ->
      switch data.action
        when 'hold' then hold data
        when 'size' then size data
        when 'drop' then drop data
        when 'nameToggle' then nameToggle data
        when 'place' then place data
        when 'editName' then editName data

    hold: (avatarId, name) ->
      window.holdWait = avatarId
      @perform 'hold', avatar_id: avatarId, name: name

    size: (value) ->
      if window.holding != undefined
        @perform 'size', avatar_id: window.holding, value: value

    drop: () ->
      @perform 'drop', avatar_id: window.holding

    place: (x, y, size, name) ->
      @perform 'place', x: x, y: y, size: size, name: name, avatar_id: window.holding

    nameToggle: () ->
      @perform 'nameToggle', avatar_id: window.holding

    editName: () ->
      @perform 'editName', avatar_id: window.holding
