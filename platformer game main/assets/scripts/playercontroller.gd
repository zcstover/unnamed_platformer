extends CharacterBody2D

signal jump_started

var is_on_ground: bool = false
var animated_sprite: AnimatedSprite2D

const GRAVITY = 1000
const JUMP_FORCE = -300
var MOVE_SPEED = 15000
var climbing = false
var climbable = false
# Reference to the crate (assuming it is a RigidBody2D)
var crate: RigidBody2D = null


func _ready():
	set_process(true)
	animated_sprite = $AnimatedSprite2D  # Replace with the actual path to your AnimatedSprite2D node
	crate = $"../Crate"
	climbing = false
	climbable = false

func _process(delta):
	# Check for left and right movement
	var move_direction = 0
	
	if !climbing:
		velocity.y += GRAVITY * delta
		
	if climbable:
		if Input.is_action_pressed("climb"):
			climbing = true
			velocity.y = -MOVE_SPEED/2 * delta
		elif Input.is_action_pressed("climb_down"):
			climbing = true
			velocity.y = MOVE_SPEED/2 * delta
		elif climbing:
			velocity.y = 0
	if Input.is_action_pressed("move_left"):
		move_direction -= 1
	if Input.is_action_pressed("move_right"):
		move_direction += 1
	if Input.is_action_pressed("sprint"):
		MOVE_SPEED = 20000
	else:
		MOVE_SPEED = 10000

	# Apply movement
	velocity.x = move_direction * MOVE_SPEED * delta

	# Flip the player animation on the Y-axis when moving to the left
	
	if move_direction < 0:
		animated_sprite.scale.x = abs(animated_sprite.scale.x) * -1
	elif move_direction > 0:
		animated_sprite.scale.x = abs(animated_sprite.scale.x)

	# Check if the player is on the ground
	is_on_ground = is_on_floor()

	# Update animations based on movement
	if climbing:
		if velocity.y != 0 && !is_on_ground:
			animated_sprite.play("climb")
		else:
			animated_sprite.pause()
	elif move_direction != 0:
		# Player is moving
		animated_sprite.play("walk")  # Replace "walk" with the name of your moving animation
	else:
		# Player is idle
		animated_sprite.play("idle")  # Replace "idle" with the name of your idle animation

	# Check for jumping with the space key
	if Input.is_action_just_pressed("jump") and (is_on_ground or climbing):
		# Apply jump force
		velocity.y = JUMP_FORCE
		emit_signal("jump_started")
		

	# Move and slide
	var collisions = move_and_collide(velocity * delta)
	move_and_slide()

	# Check for interacting with a crate
	interact_with_crate(move_direction, collisions)
	# Check if the player is colliding with climbable objects


func interact_with_crate(move_direction, collision):
	if crate:
		# Check if there is a collision and the collider is the crate
		if collision and collision.get_collider() == crate:
			# Check if the player is above the crate
			if global_position.y > crate.global_position.y and is_on_ground:
				# Optionally, you can add a limit to how far the crate can move away from the player 
				crate.global_position = crate.global_position + Vector2(move_direction * 5, 0)  # Adjust 32 based on your preference


func _on_ladder_body_entered(body):
	# Check if the entering area has the "climbable" group
	if body.name == "Player":
		climbable = true

func _on_ladder_body_exited(body):
	# Check if the exiting area has the "climbable" group
	if body.name == "Player":
		climbable = false
		climbing = false

