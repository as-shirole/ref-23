# App.web_notification = App.cable.subscriptions.create "WebNotificationChannel",
#   connected: ->
#     # Called when the subscription is ready for use on the server

#   disconnected: ->
#     # Called when the subscription has been terminated by the server

#   received: (data) ->
#     #bootbox.prompt
#     # title: 'This is a prompt with a time input!'
#     #  inputType: 'time'
#     #  callback: (result) ->
#     #    console.log result
#     #    return
#     alert("yahoo"+data['title']+data['body'])
#     # Called when there's incoming data on the websocket for this channel

#   receive: ->
#     @perform 'receive'
