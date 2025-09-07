extends Node
@onready var parent : Node2D = get_parent()
@export var color : Color :
	set(a):
		parent.modulate = a
	get():
		return parent.modulate


func _on_damage_animation_animation_finished(anim_name: StringName) -> void:
	$DamageAnimation.play("reset_hack")


func _on_i_frame_blinker_timeout() -> void:
	get_parent().sprite.visible = !get_parent().sprite.visible
