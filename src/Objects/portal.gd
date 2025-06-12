@tool
extends Area2D

@export var next_scene: PackedScene


func _on_body_entered(body: Node2D) -> void:
	teleport()


func _get_configuration_warnings() -> PackedStringArray:
	return ["The next scene property cannot be empty"] if not next_scene else []


func teleport() -> void:
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(next_scene)
