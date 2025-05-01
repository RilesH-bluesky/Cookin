extends Node2D

@export var customer_scenes : Array[PackedScene] = []
@export var spawn_delay : float = 15.0
@export var spawn_position : Vector2 = Vector2(500, 300)

var timer : float = 0.0

func _ready():
	randomize()

func _process(delta):
	timer += delta
	if timer >= spawn_delay:
		timer = 0.0
		spawn_random_customer()

func spawn_random_customer():
	if customer_scenes.is_empty():
		push_error("No customer scenes assigned!")
		return
		
	var random_customer = customer_scenes[randi() % customer_scenes.size()].instantiate()
	random_customer.position = spawn_position
	add_child(random_customer)
	
	# Verify order exists after spawn
	await get_tree().process_frame  # Let customer initialize
	if random_customer.has_method("get_order"):
		print("Spawned: ", random_customer.name, " | Order: ", random_customer.get_order())
