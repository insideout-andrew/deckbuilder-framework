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

signal mouse_entered_card(card : Card)
signal mouse_exited_card(card : Card)
signal top_card_clicked(card : Card)
signal card_clicked(card : Card)
signal card_picked_up(card : Card)
signal card_dropped(card : Card)
signal card_dropped_on_deck(card : Card, from_deck : Deck)
signal cards_updated

@export var x_spread : float = 0
@export var y_spread : float = 0
@export var max_stack_size : int = -1
@export var drag_behavior : DRAG_BEHAVIOR
@export var stack_behavior : STACK_BEHAVIOR
@export var hand_rotation_curve : Curve #This works best as a 2-point linear rise from -X to +X
@export var hand_vertical_curve : Curve # This works best as a 3-point ease in/out from 0 to X to 0

var cards : Array[Card]

func create_from_card_data(card_data : CardData):
	var card_scene = card_data.card_scene.instantiate()
	card_scene.set_card_data(card_data)
	_add_card(card_scene)
	_update_display()
	emit_signal("cards_updated")
	return card_scene

func move_card_to_deck(deck : Deck, card : Card):
	card.disconnect('mouse_entered', _on_mouse_entered_card.bind(card))
	card.disconnect('mouse_exited', _on_mouse_exited_card.bind(card))
	card.disconnect('gui_input', _on_mouse_input_card.bind(card))
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
	card.connect('mouse_entered', _on_mouse_entered_card.bind(card))
	card.connect('mouse_exited', _on_mouse_exited_card.bind(card))
	card.connect('gui_input', _on_mouse_input_card.bind(card))

func shuffle():
	var children = get_children()
	children.shuffle()
	for child in get_children():
		remove_child(child)
	for child in children:
		add_child(child)
	_update_display()

func _on_mouse_entered_card(card : Card):
	if get_children().find(card) != -1 and _no_cards_are_held(get_tree().root):
		emit_signal('mouse_entered_card', card)
	
func _on_mouse_exited_card(card : Card):
	if get_children().find(card) != -1 and _no_cards_are_held(get_tree().root):
		emit_signal('mouse_exited_card', card)

func _on_mouse_input_card(event, card : Card):
	if event is InputEventMouseButton and get_children().find(card) != -1:
		if card.get_index() == get_child_count() - 1:
			emit_signal('top_card_clicked', card)
		emit_signal('card_clicked', card)

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
