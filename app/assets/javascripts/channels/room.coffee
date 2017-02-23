$(document).on 'ready', () ->
	id = $("#output").attr("class")
	App.room = App.cable.subscriptions.create { channel: "RoomChannel", message: id},
	  connected: (data) ->
	  	
	    # Called when the subscription is ready for use on the server

	  disconnected: ->
	    # Called when the subscription has been terminated by the server

	  received: (data) ->
	  	alert("kksdlk")
	  	$("#final").append("<p>"+ data['message']+ "</p>")
	  	# alert data['message']
	    # Called when there's incoming data on the websocket for this channel

	  speak: (message, id)->
	    @perform 'speak', message: message, room_id: id
	$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
		if event.keyCode is 13
			id = $("#output").attr("class")
			alert(id)
			App.room.speak event.target.value , id
			event.target.value = ''
			event.preventDefault()