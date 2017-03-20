$(document).on 'turbolinks:load', () ->
  if $( "#chat_room_id" ).length 
    chat_room_id = $("#chat_room_id").attr("class")
    App.room = App.cable.subscriptions.create { channel: "RoomChannel", chat_room_id: chat_room_id},

      connected: (data) ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        # alert("skjskjs")
        # alert("kksdlk"+data['message'])
        $("#messages").append(data['message'])
        # alert data['message']
        # Called when there's incoming data on the websocket for this channel

      speak: (message, chat_room_id, user_id)->
        @perform 'speak', message: message, chat_room_id: chat_room_id, user_id: user_id
    $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
      if event.keyCode is 13
        if event.target.value == "" || event.target.value == " "
          alert("Please enter valid comment")
        else
          chat_room_id = $("#chat_room_id").attr("class")
          user_id = $("#user_id").attr("class")
          App.room.speak event.target.value, chat_room_id, user_id
          event.target.value = ''
          event.preventDefault()