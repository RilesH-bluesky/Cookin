extends Marker2D
class_name FloatingUI

signal order_taken
var button_instance : Button

func show_button():
	var button_scene = preload("res://take_order_button.tscn")
	button_instance = button_scene.instantiate()  # Assign to button_instance!
	
	# Configure button
	button_instance.custom_minimum_size = Vector2(80, 30)
	button_instance.scale = Vector2(0.7, 0.7)
	button_instance.pressed.connect(_on_order_button_pressed)  # Connect signal
	
	add_child(button_instance)

func _on_order_button_pressed():
	emit_signal("order_taken")  # Will trigger Capy's _on_order_taken
	hide_button()


func hide_button():
	if button_instance:
		button_instance.queue_free()
		button_instance = null  # Clear reference
