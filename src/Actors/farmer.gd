extends Actor

@export var stomp_impulse: float = 1000.0


# Prevents Camera starting outside limits on start
func _on_camera_smoothing_timer_timeout() -> void:
	$Camera2D.position_smoothing_enabled = true


func _on_enemy_detector_area_entered(_area: Area2D) -> void:
	velocity = calculate_stomp_velocity(velocity, stomp_impulse)


func _on_enemy_detector_body_entered(_body: Node2D) -> void:
	queue_free()


func _physics_process(_delta: float) -> void:
	var is_jump_interrupted: bool = Input.is_action_just_released("jump") and velocity.y < 0.0
	var direction: Vector2 = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)
	move_and_slide()


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)


func calculate_move_velocity(
		linear_velocigy: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: Vector2 = linear_velocigy
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out


func calculate_stomp_velocity(
		linear_velocigy: Vector2,
		impulse: float
	) -> Vector2:
	var out: Vector2 = linear_velocigy
	out.y = -impulse
	return out
