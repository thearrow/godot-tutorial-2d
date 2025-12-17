extends Area2D

signal hit

@export var speed = 400
var screen_size

# called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

# called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	# add velocity based on key press
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		# prevent fast diagonal movement
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# pick the animation and flip it depending on movement direction
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

	# consistent movement despite frame rate changes
	position += velocity * delta
	# prevent player from leaving screensd
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node2D) -> void:
	hide() # player disappears after being hit
	hit.emit()
	# wait until it's safe to disable collision on the player
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false
