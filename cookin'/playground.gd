extends Node

func _ready():
	# Load the customer scene
	var customer_scene = preload("res://1Customer/scenes/CapybaraCustomer.tscn")
	# Create an instance of the customer
	var customer = customer_scene.instantiate()
	# Add it to the scene tree
	add_child(customer)
	# Optionally set its position
	customer.position = Vector2(387, 267) # Set your desired position
