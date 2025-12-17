extends Node

@export var mob_scene: PackedScene
var score

# called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	
func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_mob_timer_timeout() -> void:
	# create a new instance of the Mob scene
	var mob = mob_scene.instantiate()

	# choose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# set the mob's position to the random location
	mob.position = mob_spawn_location.position

	# set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2

	# add some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# spawn the mob by adding it to the Main scene
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
