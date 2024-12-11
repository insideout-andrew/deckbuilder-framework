class_name Deck extends Control

enum DRAG_BEHAVIOR {
	NONE,
	ALL,
	TOP,
	CUSTOM
}

enum STACK_BEHAVIOR {
	EXACT,
	CENTERED
}

enum CARD_DRAG_OVER_CARD_BEHAVIOR {
	NONE,
	SWAP_POSITIONS
}

signal mouse_entered_card(card : Card)
signal mouse_exited_card(card : Card)
signal top_card_clicked(card : Card)
signal card_clicked(card : Card)
signal card_picked_up(card : Card)
signal card_dropped(card : Card, dropped_on_deck : Deck)
signal cards_updated
signal start_card_drag(card : Card)

@export var x_spread : float = 0
@export var y_spread : float = 0
@export var max_stack_size : int = -1
@export var drag_behavior : DRAG_BEHAVIOR
@export var stack_behavior : STACK_BEHAVIOR
@export var card_drag_over_card_behavior : CARD_DRAG_OVER_CARD_BEHAVIOR
@export var hand_rotation_curve : Curve #This works best as a 2-point linear rise from -X to +X
@export var hand_vertical_curve : Curve # This works best as a 3-point ease in/out from 0 to X to 0

var cards : Array[Card]
var held_card : Card
var return_card_to_index_when_dropped : int
var held_card_has_been_exited := false # we only want to emit the mouse_entered signal if the held card has been existed, otherwise you drop it, then mouse entered fires immediately when you move

func create_from_card_data(card_data : CardData):
	var card_scene = card_data.card_scene.instantiate()
	card_scene.set_card_data(card_data)
	_add_card(card_scene)
	_update_display()
	emit_signal("cards_updated")
	return card_scene

func move_card_to_deck(deck : Deck, card : Card):
	if card.is_connected('mouse_entered', _on_mouse_entered_card.bind(card)):
		card.disconnect('mouse_entered', _on_mouse_entered_card.bind(card))
		card.disconnect('mouse_exited', _on_mouse_exited_card.bind(card))
		card.disconnect('gui_input', _on_gui_input_card.bind(card))
	var last_pos = card.global_position
	remove_child(card)
	_update_display()
	emit_signal("cards_updated")
	deck._add_card(card)
	deck._update_display()
	deck.emit_signal("cards_updated")
	card.global_position = last_pos

func _add_card(card : Card):
	add_child(card)
	if not card.is_connected('mouse_entered', _on_mouse_entered_card.bind(card)):
		card.connect('mouse_entered', _on_mouse_entered_card.bind(card))
		card.connect('mouse_exited', _on_mouse_exited_card.bind(card))
		card.connect('gui_input', _on_gui_input_card.bind(card))

func is_holding_a_card():
	return held_card != null

# when a card is picked up 
# turn off its mouse interactions so it can interact with cards below it 
# then set its z_index up so it *looks* like it is on top
func _handle_card_picked_up(card : Card):
	held_card_has_been_exited = false
	held_card = card
	held_card.z_index = 1
	emit_signal('card_picked_up', card)
	card.propagate_call("set_mouse_filter", [ Control.MOUSE_FILTER_IGNORE ])

func _input(event: InputEvent) -> void:
	if held_card and event is InputEventMouseButton and not event.is_pressed():
		emit_signal('card_dropped', held_card, _get_deck_at_position(get_global_mouse_position(), get_tree().root))
		emit_signal('mouse_exited_card', held_card)
		held_card.mouse_filter = Control.MOUSE_FILTER_STOP
		held_card.is_held = false
		held_card.is_dragging = false
		held_card.z_index = 0
		var temp = held_card
		held_card = null

func _on_mouse_entered_card(card : Card):
	if card == held_card:
		return
	if get_children().find(card) != -1:
		if held_card and card_drag_over_card_behavior == CARD_DRAG_OVER_CARD_BEHAVIOR.SWAP_POSITIONS:
			var held_index = held_card.get_index()
			var hover_index = card.get_index()
			if held_index < hover_index:
				for i in range(held_index, hover_index):
					move_child(get_child(i + 1), i)
			elif held_index > hover_index:
				for i in range(held_index, hover_index, -1):
					move_child(get_child(i - 1), i)
			move_child(held_card, hover_index)
			_update_display()
		if card != held_card:
			emit_signal('mouse_entered_card', card)

func shuffle():
	var children = get_children()
	children.shuffle()
	for child in get_children():
		remove_child(child)
	for child in children:
		add_child(child)
	_update_display()

func _on_mouse_exited_card(card : Card):
	if card != held_card and get_children().find(card) != -1:
		emit_signal('mouse_exited_card', card)

func _on_gui_input_card(event, card : Card):
	if event is InputEventMouseButton and event.pressed and get_children().find(card) != -1:
		emit_signal('card_clicked', card)
		if card.get_index() == get_child_count() - 1:
			emit_signal('top_card_clicked', card)

func _update_display():
	for card in get_children():
		if max_stack_size != -1:
			var max_spread = min(max_stack_size - 1, card.get_index())
			card.target_position.x = position.x + max_spread * x_spread
			card.target_position.y = position.y + max_spread * y_spread
			card.target_rotation = 0
			card.update_display()
		else:			
			if stack_behavior == STACK_BEHAVIOR.CENTERED:
				var hand_ratio = 0.5
				if get_child_count() > 1:
					hand_ratio = float(card.get_index()) / float(get_child_count() - 1)
				var middle_index = get_child_count() / 2.0
				var offset = card.get_index() - middle_index + 0.5
				var max_spread = min(max_stack_size - 1, abs(offset))
				card.target_position.x = ((size.x * 0.5) - (card.size.x * 0.5)) + position.x + (offset * x_spread)
				card.target_position.y = ((size.y * 0.5) - (card.size.y * 0.5)) + position.y + (offset * y_spread)
				if hand_rotation_curve:
					card.target_rotation = deg_to_rad(hand_rotation_curve.sample(hand_ratio))
				if hand_vertical_curve:
					card.target_position.y -= hand_vertical_curve.sample(hand_ratio)
				card.update_display()
			else:
				var middle_index = get_child_count() / 2.0
				var offset = card.get_index()
				var max_spread = min(max_stack_size - 1, abs(offset))
				card.target_position.x = position.x + offset * x_spread
				card.target_position.y = position.y + offset * y_spread
				card.target_rotation = 0
				card.update_display()

func _no_cards_are_held(node: Node) -> bool:
	if node is Card and node.is_held:
		return false
	for child in node.get_children():
		if not _no_cards_are_held(child):
			return false
	return true

func get_top_card():
	if get_child_count():
		return get_child(-1)
	return null

func custom_can_card_be_dragged(_card : Card):
	return false


func _get_deck_at_position(global_pos: Vector2, node: Node) -> Deck:
	if node is Deck and (node as Deck).get_global_rect().has_point(global_pos):
		return node
	for child in node.get_children():
		if child is Node:
			var found = _get_deck_at_position(global_pos, child)
			if found:
				return found
	return null
