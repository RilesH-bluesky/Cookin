class_name CapyCustomer
extends CharacterBody2D

# Customer properties
@export var texture : Texture2D
@export var customer_name : String = "Guest"

# Movement properties
@onready var path_follow : PathFollow2D = get_parent()
var is_walking := true
var walk_speed : float = 50.0

# Order system
var menu_items = [
	{"name": "Caramel Latte", "prep_time": 8.0},
	{"name": "Matcha Latte", "prep_time": 7.0},
	{"name": "Fluffy Croissant", "prep_time": 2.0},
	{"name": "Decaf Drip", "prep_time": 5.0},
	{"name": "Pink Tea", "prep_time": 6.0}
]
var current_order : Array = []

signal order_generated(customer, order_items)
signal order_taken(customer)

func _ready():
	setup_customer()
	await get_tree().create_timer(1.0).timeout  
	walk_along_path()
	$UIPosition.order_taken.connect(_on_order_taken, CONNECT_ONE_SHOT)

func setup_customer():
	# Apply appearance
	if texture:
		$Sprite2D.texture = texture
	
	# Generate and store order
	current_order = generate_order()
	print("%s wants: %s" % [customer_name, get_order_names()])
	emit_signal("order_generated", self, current_order)

func generate_order() -> Array:
	var order = []
	var num_items = randi_range(1, 3)  # 1-3 items
	var available_items = menu_items.duplicate()
	
	for i in range(num_items):
		if available_items.is_empty():
			break
		var random_index = randi() % available_items.size()
		order.append(available_items[random_index])
		available_items.remove_at(random_index)
	
	return order

func get_order() -> Array:
	return current_order

func get_order_names() -> Array:
	return current_order.map(func(item): return item["name"])

func walk_along_path():
	if !is_walking: return
	
	var tween = create_tween()
	tween.tween_property(path_follow, "progress_ratio", 1.0, 3.0)
	tween.tween_callback(stop_walking)

func stop_walking():
	is_walking = false
	print("Reached counter!")
	$UIPosition.show_button()

func _on_order_taken():
	var textbox = preload("res://UI/text box/text_box.tscn").instantiate()
	textbox.set_opacity(0.8)  # Set 80% opaque background
	get_tree().root.add_child(textbox)
	
	# Position above capybara's head (adjust -50 as needed)
	var head_position = global_position + Vector2(10, -30)
	textbox.display_order(get_order_names(), head_position)
	emit_signal("order_taken", self)
