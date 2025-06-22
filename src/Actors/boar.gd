extends Actor


func _ready() -> void:
	velocity.x = -speed.x


func _on_hit_detector_area_entered(area: Area2D) -> void:
	if area.name == "SwordAttack":
		is_dead = true
		$boar.play("hit")
		await $boar.animation_finished
		queue_free()


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if is_dead:
		velocity = Vector2.ZERO
	if is_on_wall():
		velocity.x *= -1
	move_and_slide()
