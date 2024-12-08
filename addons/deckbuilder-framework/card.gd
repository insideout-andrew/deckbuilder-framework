class_name Card extends Control

var card_data : CardData
var is_ready : bool = false
var target_position : Vector2
var target_rotation : float
var is_held : bool = false
var auto_position_enabled : bool = true

func _ready():
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

func _process(_delta: float) -> void:
	if auto_position_enabled:
		if is_held:
			rotation = 0
			global_position = get_global_mouse_position() - size * 0.5
		else:
			rotation = lerp_angle(rotation, target_rotation, 0.25)
			global_position = lerp(global_position, target_position, 0.25)

func _on_gui_input(event):
	if event is InputEventMouseButton and _parent_allows_drag():
		var parent = get_parent() as Deck
		if is_held:
			z_index = 0
			var deck = _get_deck_at_position(get_global_mouse_position(), get_tree().root)
			if deck:
				deck.emit_signal('card_dropped_on_deck', self, get_parent())
			parent.emit_signal('card_dropped', self)
		else:
			z_index = 1
			parent.emit_signal('card_picked_up', self)
		is_held = event.pressed

func _parent_allows_drag():
	var parent = get_parent() as Deck
	if parent:
		if parent.drag_behavior == Deck.DRAG_BEHAVIOR.ALL:
			return true
		if parent.drag_behavior == Deck.DRAG_BEHAVIOR.TOP:
			return parent.get_child(parent.get_child_count() - 1) == self
		if parent.drag_behavior == Deck.DRAG_BEHAVIOR.CUSTOM:
			return parent.custom_can_card_be_dragged(self)
		
func _get_deck_at_position(global_pos: Vector2, node: Node) -> Deck:
	if node is Deck and (node as Deck).get_global_rect().has_point(global_pos):
		return node
	for child in node.get_children():
		if child is Node:
			var found = _get_deck_at_position(global_pos, child)
			if found:
				return found
	return null
