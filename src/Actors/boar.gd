extends Actor

var facing: Vector2 = Vector2.LEFT
var farmer: Node2D = null
var run_factor: float = 1.5


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	$PacingTimer.start()


func _on_pacing_timer_timeout() -> void:
	$PauseTimer.start()


func _on_pause_timer_timeout() -> void:
	turn()
	$PacingTimer.start()


func _on_proximity_detector_body_entered(body: Node2D) -> void:
	farmer = body
	$PacingTimer.stop()
	$PauseTimer.stop()


func _on_proximity_detector_body_exited(_body: Node2D) -> void:
	farmer = null
	$PauseTimer.start()


func _on_hit_detector_area_entered(area: Area2D) -> void:
	if area.name == "SwordAttack":
		is_dead = true
		$PacingTimer.stop()
		$PauseTimer.stop()
		$boar.play("hit")
		await $boar.animation_finished
		queue_free()


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	set_animation()
	if farmer:
		if facing.dot(position.direction_to(farmer.position)) < 0:
			turn()
		velocity.x = facing.x * speed.x * run_factor
	elif $PauseTimer.is_stopped():
		velocity.x = facing.x * speed.x
	else:
		velocity = Vector2.ZERO
	velocity.y += gravity * delta
	move_and_slide()


func turn() -> void:
	facing.x *= -1
	$boar.flip_h = facing.x > 0


func set_animation() -> void:
	if not $PauseTimer.is_stopped():
		$boar.play("idle")
	elif farmer:
		$boar.play("run")
	else:
		$boar.play("walk")
