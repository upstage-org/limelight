hold = (data) ->
  btn = document.querySelector ".avatar-selection[data-avatar-id='#{data.avatar_id}']"
  btn.setAttribute 'disabled', 'disabled'
  if `data.avatar_id == window.holdWait`
    dropButton = document.querySelector '#dropAvatarButton'
    dropButton.removeAttribute 'disabled'
    dropButton.dataset.avatarId = data.avatar_id
    window.holdWait = undefined


document.addEventListener 'turbolinks:load', (e) ->
  document.querySelectorAll('.avatar-selection').forEach (elem) ->
    elem.addEventListener 'mouseup', (e) ->
      App.avatar.hold this.dataset.avatarId

  slug = document.querySelector('meta[name="stage-slug"]').getAttribute('value')

  App.avatar = App.cable.subscriptions.create { channel:"AvatarChannel", slug: slug },
    received: (data) ->
      switch data.action
        when 'hold' then hold data

    hold: (avatarId) ->
      window.holdWait = avatarId
      @perform 'hold', avatar_id: avatarId
