utter = (data) ->
  window.speechSynthesis.speak new SpeechSynthesisUtterance(data.dialog)

document.addEventListener 'turbolinks:load', (e) ->
  App.dialog = App.cable.subscriptions.create { channel:"DialogChannel", slug: App.slug },
    received: (data) ->
      switch data['action']
        when 'utter' then utter data

    utter: (dialog) ->
      @perform 'utter', dialog: dialog
