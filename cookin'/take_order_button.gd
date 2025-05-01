extends Button

func _on_button_pressed():
	print("Take Order button pressed!")  # Keep this if you want button feedback
	# Let FloatingUI handle the rest
	if get_parent().has_method("_on_order_button_pressed"):
		get_parent()._on_order_button_pressed()
