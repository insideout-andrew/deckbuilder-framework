extends Control

# load all playing cards
var all_cards = [
	preload("res://addons/deckbuilder-framework/playing-cards/spades/2.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/3.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/4.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/5.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/6.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/7.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/8.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/9.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/10.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/j.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/q.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/k.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/spades/a.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/2.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/3.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/4.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/5.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/6.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/7.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/8.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/9.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/10.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/j.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/q.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/k.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/hearts/a.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/2.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/3.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/4.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/5.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/6.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/7.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/8.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/9.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/10.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/j.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/q.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/k.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/clubs/a.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/2.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/3.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/4.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/5.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/6.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/7.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/8.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/9.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/10.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/j.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/q.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/k.tres"),
	preload("res://addons/deckbuilder-framework/playing-cards/diamonds/a.tres")
]


@onready var draw_deck: Deck = $Draw
@onready var hand: Deck = $Hand
@onready var discard: Deck = $Discard

@onready var draw_label: Label = $DrawLabel
@onready var discard_label: Label = $DiscardLabel
@onready var hand_label: Label = $HandLabel

@onready var back_button: Button = $BackButton

func _ready() -> void:
	_connect_signals()
	_create_cards()
	_shuffle_and_draw_starting_hand()

func _create_cards():
	for card_data in all_cards:
		var card = draw_deck.create_from_card_data(card_data)
		card.set_flipped(true)
	draw_deck.shuffle()
	
func _shuffle_and_draw_starting_hand():
	randomize()
	for _i in range(7):
		var card : PlayingCard = draw_deck.get_top_card()
		draw_deck.move_card_to_deck(hand, card)
		card.set_flipped(false)
		await get_tree().create_timer(0.1).timeout

func _connect_signals():
	back_button.connect('pressed', func(): get_tree().change_scene_to_file("res://example.tscn"))

	# handle deck interactions
	draw_deck.connect('top_card_clicked', _draw_pile_clicked)
	draw_deck.connect('cards_updated', _on_deck_updated)
	
	# handle hand interactions
	hand.connect('mouse_entered_card', _mouse_entered_card_in_hand)
	hand.connect('mouse_exited_card', _mouse_exited_card_in_hand)
	hand.connect('start_card_drag', _start_drag_card_in_hand)
	hand.connect('cards_updated', _on_hand_updated)
	hand.connect('card_picked_up', _on_card_picked_up_from_hand)
	hand.connect('card_dropped', _on_card_dropped_from_hand)
	
	# handle discard interactions
	discard.connect('top_card_clicked', _dicard_clicked)
	discard.connect('cards_updated', _on_discard_updated)
	
# draw interactions
# -----------------

func _draw_pile_clicked(card : PlayingCard):
	if hand.get_child_count() < 7:
		card.set_flipped(false)
		draw_deck.move_card_to_deck(hand, card)

func _on_deck_updated():
	draw_label.text = "Deck (%s)" % draw_deck.get_child_count()


# hand interactions
# -----------------

func _mouse_entered_card_in_hand(card : PlayingCard):
	card.play_animation('enter_hover')

func _mouse_exited_card_in_hand(card : PlayingCard, was_being_held : bool):
	if not was_being_held:
		card.play_animation('exit_hover')

func _start_drag_card_in_hand(card : PlayingCard):
	card.play_animation('RESET')

func _on_card_picked_up_from_hand(_card : PlayingCard):
	discard_label.text = "Drop to discard (%s)" % discard.get_child_count()

func _on_card_dropped_from_hand(card : PlayingCard, dropped_on_deck : Deck):
	discard_label.text = "Discard (%s)" % discard.get_child_count()
	if dropped_on_deck == discard:
		hand.move_card_to_deck(discard, card)

func _on_hand_updated():
	hand_label.text = "Hand (%s)" % hand.get_child_count()


# discard interactions
# -----------------

func _dicard_clicked(_card : PlayingCard):
	for card in discard.get_children():
		card.set_flipped(true)
		discard.move_card_to_deck(draw_deck, card)
	draw_deck.shuffle()

func _on_discard_updated():
	discard_label.text = "Discard (%s)" % discard.get_child_count()
