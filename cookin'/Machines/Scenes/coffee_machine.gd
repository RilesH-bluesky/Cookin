extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
#	if sprite_2d.frame == 0: | This and the line below are for updating the sprite when interacted with
#		sprite_2d.frame = 1
	interactable.is_interactable = false
	print("the player has collected a drink")
