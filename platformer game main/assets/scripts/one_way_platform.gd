extends RigidBody2D


func _on_body_entered(body):
	print("test")
	# Check if the entering body is the player
	if body.is_in_group("player"):
		# Check player's direction (velocity.y > 0 means moving upwards)
		if body.velocity.y > 0:
			# Allow the player to pass through
			queue_free()  # or hide the platform, disable collisions, etc.
