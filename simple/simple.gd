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

func _connect_signals():
	back_button.connect('pressed', func(): get_tree().change_scene_to_file("res://example.tscn"))
	draw_deck.connect('top_card_clicked', _draw_pile_clicked)
	hand.connect('card_dropped', _on_card_dropped_from_hand)
	discard.connect('top_card_clicked', _dicard_clicked)

func _create_cards():
	for card_data in all_cards:
		var card = draw_deck.create_from_card_data(card_data)
		card.set_flipped(true)

func _shuffle_and_draw_starting_hand():
	randomize()
	draw_deck.shuffle()
	for _i in range(7):
		var card : PlayingCard = draw_deck.get_top_card()
		draw_deck.move_card_to_deck(hand, card)
		card.set_flipped(false)
	
# draw interaction
# -----------------
func _draw_pile_clicked(card : PlayingCard):
	if hand.get_child_count() < 16:
		card.set_flipped(false)
		draw_deck.move_card_to_deck(hand, card)

# hand interaction
# -----------------
func _on_card_dropped_from_hand(card : PlayingCard, dropped_on_deck : Deck):
	if dropped_on_deck == discard:
		hand.move_card_to_deck(discard, card)


# discard interactions
# -----------------
func _dicard_clicked(_card : PlayingCard):
	for card in discard.get_children():
		card.set_flipped(true)
		discard.move_card_to_deck(draw_deck, card)
	draw_deck.shuffle()
