extends MarginContainer

signal ticket_clicked

# Node Reference (using the working unique name)
@onready var label: Label = %OrderLabel
@onready var background: NinePatchRect = $NinePatchRect

# Debug State Tracking
var _initialized := false
var _order_received := false

func _ready():
	_initialize_label()

func _initialize_label():
	if !is_instance_valid(label):
		# Last-resort direct search
		label = find_child("Label", true, false)
		if !label:
			_create_emergency_label()
			return
	
	# PROPER initialization
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 7
	label.label_settings.font_color = Color.BLACK
	label.text = "INIT SUCCESS"
	
	if _order_received:
		_update_label_content()
	
	_initialized = true
	print("Label initialized:", label.get_path())

func display_order(order_items: Array):
	if !_initialized:
		_order_received = true
		return
	
	_update_label_content(order_items)

func _update_label_content(order_items := []):
	if !is_instance_valid(label):
		push_error("Label invalid during update!")
		return
	
	var display_text := "• " + "\n• ".join(order_items)
	label.text = display_text
	print("Displaying order:", display_text)

func _create_emergency_label():
	push_error("Creating emergency label!")
	label = Label.new()
	label.name = "EmergencyLabel"
	label.text = "SCENE BROKEN - FIX LABEL NODES"
	add_child(label)
	_initialized = true

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("ticket_clicked")
