extends Area2D

var player_on_door = false
var new_scene = {
	"scene_one": "res://platformer game main/scene/second_scene.tscn",
	"scene_two": "res://platformer game main/scene/contra scene.tscn",
	"contra's scene": "res://platformer game main/scene/main.tscn"
}

func _on_body_entered(body):
	# Check if the entering body is the player
	if body.is_in_group("Player"):
		# Check player's direction (velocity.y > 0 means moving upwards)
		player_on_door = true

func _on_body_exited(body):
	# Check if the entering body is the player
	if body.is_in_group("Player"):
		# Check player's direction (velocity.y > 0 means moving upwards)
		player_on_door = false
		
func _process(delta):
	if player_on_door:
		if Input.is_action_pressed("interact"):
			change_scene(new_scene[get_tree().current_scene.get_name()])
			
# Change to a new scene
# Change to a new scene
func change_scene(new_scene_path):
	# Get the current scene tree
	get_tree().change_scene_to_file(new_scene_path)

