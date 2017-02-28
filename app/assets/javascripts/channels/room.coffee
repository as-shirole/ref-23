# $(document).on 'ready', () ->
# 	post_id = $("#post_id").attr("class")
# 	App.room = App.cable.subscriptions.create { channel: "RoomChannel", post_id: post_id},

# 	  connected: (data) ->
# 	    # Called when the subscription is ready for use on the server

# 	  disconnected: ->
# 	    # Called when the subscription has been terminated by the server

# 	  received: (data) ->
# 	  	# alert("kksdlk")
# 	  	$("#messages").append(data['message'])
# 	  	# alert data['message']
# 	    # Called when there's incoming data on the websocket for this channel

# 	  speak: (message, post_id, user_id)->
# 	    @perform 'speak', message: message, post_id: post_id, user_id: user_id
# 	$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
# 		if event.keyCode is 13
# 			if event.target.value == "" || event.target.value == " "
# 				alert("Please enter valid comment")
# 			else
# 				post_id = $("#post_id").attr("class")
# 				user_id = $("#user_id").attr("class")
# 				App.room.speak event.target.value, post_id, user_id
# 				event.target.value = ''
# 				event.preventDefault()