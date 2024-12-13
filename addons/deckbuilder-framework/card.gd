class_name Card extends Control

var card_data : CardData
var is_ready : bool = false
var target_position : Vector2
var target_rotation : float
var mouse_down_point : Vector2
var is_held : bool = false
var is_dragging : bool = false
var auto_position_enabled : bool = true

@export var speed = 15.0

func _ready():
	# the card doesn't connect to any main signals - we just let the deck do that
	# however, this should probably emit at least a few signals for games? 
	
	# ignore all clicks on the card except on the root node
	propagate_call("set_mouse_filter", [ Control.MOUSE_FILTER_IGNORE ])
	set_mouse_filter(Control.MOUSE_FILTER_STOP)
	
	pivot_offset = size / 2
	is_ready = true
	target_position = global_position
	update_display()
	connect('gui_input', _on_gui_input)

func set_card_data(_card_data):
	card_data = _card_data
	if is_ready:
		update_display()

func set_auto_position_enabled(val : bool):
	auto_position_enabled = val

func update_display():
	pass

func _should_drag():
	return mouse_down_point != Vector2.ZERO and mouse_down_point != get_global_mouse_position() and is_held

func _process(delta: float) -> void:
	if auto_position_enabled and is_ready:
		if _should_drag():
			if not is_dragging:
				var parent = get_parent() as Deck
				if parent:
					parent.emit_signal('start_card_drag', self)
				is_dragging = true
			rotation = 0
			global_position = get_global_mouse_position() - size * 0.5
		else:
			rotation = lerp_angle(rotation, target_rotation, speed * delta)
			var center_offset = (size * 0.5).rotated(rotation)
			global_position = lerp(global_position, (target_position - center_offset) + (size * 0.5), speed * delta)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and _parent_allows_drag():
			is_held = true
			mouse_down_point =  get_global_mouse_position()
			var parent_deck = get_parent() as Deck
			parent_deck._handle_card_picked_up(self)
		
func _parent_allows_drag():
	var parent = get_parent() as Deck
	if parent:
		if parent.held_card:
			return false
		if parent.drag_behavior == Deck.DRAG_BEHAVIOR.ALL:
			return true
		if parent.drag_behavior == Deck.DRAG_BEHAVIOR.TOP:
			return parent.get_child(parent.get_child_count() - 1) == self
		if parent.drag_behavior == Deck.DRAG_BEHAVIOR.CUSTOM:
			return parent.custom_can_card_be_dragged(self)
