class_name FellaCustomer
extends CharacterBody2D

# Customer properties
@export var texture : Texture2D
@export var customer_name : String = "Guest"

# Order system
var menu_items = [
	"Caramel Latte",
	"Matcha Latte",
	"Fluffy Croissant",
	"Decaf Drip",
	"Pink Tea"
]
var current_order : Array = []

func _ready():
	setup_customer()
	setup_click_detection()

func setup_customer():
	# Apply appearance
	if texture:
		$Sprite2D.texture = texture
	else:
		push_warning("No texture assigned")
	
	# Generate and store order
	current_order = generate_order()
	print("%s wants: %s" % [customer_name, current_order])

func setup_click_detection():
	# Enable input processing for the entire customer
	set_process_input(true)

func generate_order():
	var order = []
	var num_items = randi() % 3 + 1  # 1-3 items
	for i in range(num_items):
		order.append(menu_items[randi() % menu_items.size()])
	return order

func get_order():
	return current_order

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Convert mouse position to local space
		var mouse_pos = get_local_mouse_position()
		# Get sprite's Rect2 in local coordinates
		var sprite_rect = Rect2(Vector2.ZERO, $Sprite2D.texture.get_size())
		# Check if click is within sprite bounds
		if sprite_rect.has_point(mouse_pos - $Sprite2D.position):
			print("CLICKED: %s's order: %s" % [customer_name, current_order])
			
			# Visual feedback
			var tween = create_tween()
			tween.tween_property($Sprite2D, "scale", Vector2(1.1, 1.1), 0.1)
			tween.tween_property($Sprite2D, "scale", Vector2(1.0, 1.0), 0.1)
