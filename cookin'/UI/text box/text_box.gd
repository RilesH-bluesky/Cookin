extends MarginContainer

# Node References
@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer
@onready var background: NinePatchRect = $NinePatchRect
@onready var close_button: TextureButton = $CloseButton

# Display Settings
const MAX_WIDTH = 180
const FONT_SIZE = 7
var text = ""
var letter_index = 0
var current_order = []

# Timing Controls
var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

# Signals
signal finished_displaying()

func _ready():
	close_button.pressed.connect(_on_close_pressed)  # Proper connection
	close_button.hide()
	
	if background:
		background.modulate.a = 0.5  # Default opacity
	else:
		push_warning("Background node not found!")
	# Initialize label settings with default font
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = FONT_SIZE
	label.label_settings.font_color = Color.BLACK
	
	# Load your pixel font if available
	var font = FontFile.new()
	var font_data = load("res://UI/fonts/PressStart2P-Regular.ttf")
	if font_data:
		font.font_data = font_data
		font.antialiasing = TextServer.FONT_ANTIALIASING_NONE
		label.label_settings.font = font
		
func _on_close_pressed() -> void:
	# 1. Hide the text box
	hide()
	
	# 2. Create the ticket
	var ticket = preload("res://UI/ticket hanger/ticket_hanger.tscn").instantiate()
	
	# 3. Add it to the scene tree (IMPORTANT!)
	get_parent().add_child(ticket)
	
	# 4. Position it in top-right
	ticket.position = Vector2(
		get_viewport_rect().size.x - 460,  # Right side
		-60                                # Near top
	)
	
	# 5. Display the order (CRUCIAL!)
	ticket.display_order(current_order)
	
func _on_ticket_clicked(ticket: TextureRect):
	print("Ticket clicked!")
	
func display_order(order_items: Array, target_position: Vector2):
	current_order = order_items
	var display_text = format_order_text(order_items)
	display_text(display_text, target_position)

func format_order_text(items: Array) -> String:
	var formatted_text = "ORDER:\n"
	for i in range(items.size()):
		formatted_text += "• " + items[i]
		if i < items.size() - 1:
			formatted_text += "\n"
	return formatted_text

func display_text(text_to_display: String, target_position: Vector2):
	text = text_to_display
	label.text = text_to_display
	
	await get_tree().process_frame
	
	# Get font safely
	var font = label.label_settings.font
	var font_size = label.label_settings.font_size
	
	# Fallback if font is null
	if not font:
		push_warning("Using default font fallback")
		font = ThemeDB.get_project_theme().default_font
	
	# Calculate size
	var text_size = font.get_string_size(text_to_display, font_size)
	var target_width = min(text_size.x + 20, MAX_WIDTH)
	var line_count = text_to_display.count("\n") + 1
	var target_height = line_count * (font_size + 2)
	
	custom_minimum_size = Vector2(target_width, target_height)
	size = custom_minimum_size
	
	# Position above target
	global_position = target_position - Vector2(size.x/2, size.y + 10)
	
	# Start animation
	label.text = ""
	letter_index = 0
	_display_letter()
	finished_displaying.connect(func(): close_button.show(), CONNECT_ONE_SHOT)
	
	finished_displaying.connect(func(): 
		close_button.show()
		close_button.modulate.a = background.modulate.a if background else 1.0
	, CONNECT_ONE_SHOT)

func _display_letter():
	if letter_index < text.length():
		label.text += text[letter_index]
		letter_index += 1
		
		# Set appropriate timer delay
		var delay = letter_time
		if letter_index < text.length():
			match text[letter_index]:
				"!", ",", ".", "?":
					delay = punctuation_time
				" ":
					delay = space_time
		
		timer.start(delay)
	else:
		finished_displaying.emit()

func _on_letter_display_timer_timeout():
	_display_letter()

func set_opacity(amount: float) -> void:
	var opacity = clamp(amount, 0.8, 0.8)
	
	# Set background opacity
	if background:
		background.modulate.a = opacity
	else:
		push_warning("Cannot set opacity - background node missing")
	
	# Set close button opacity (only when visible)
	if close_button and close_button.visible:
		close_button.modulate.a = opacity
		
