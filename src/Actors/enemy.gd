extends Actor


func _ready() -> void:
	velocity.x = -speed.x


func _on_stomp_detector_body_entered(body: Node2D) -> void:
	if body.global_position.y > $StompDetector.global_position.y:
		return
	queue_free()


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if is_on_wall():
		velocity.x *= -1
	move_and_slide()
