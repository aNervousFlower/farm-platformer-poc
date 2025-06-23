extends Actor


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	$boar.play("walk")
	velocity.x = -speed.x
	$PacingTimer.start()


func _on_pacing_timer_timeout() -> void:
	$boar.play("idle")
	$PauseTimer.start()


func _on_pause_timer_timeout() -> void:
	velocity.x *= -1
	$boar.flip_h = velocity.x > 0
	$boar.play("walk")
	$PacingTimer.start()


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
		velocity = Vector2.ZERO
		
	velocity.y += gravity * delta
	#if is_on_wall():
		#velocity.x *= -1
	if $PauseTimer.is_stopped():
		move_and_slide()
