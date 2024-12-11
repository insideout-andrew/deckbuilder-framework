extends Control


# first preload all cards
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

# `Button`s
@onready var refresh_button: Button = $Buttons/RefreshButton
@onready var back_button: Button = $Buttons/BackButton


# `Deck`s
@onready var draw_pile: Deck = $Decks/DrawPile
@onready var discard: Deck = $Decks/Discard


# `BuildDeck`s
@onready var build_deck_1: Deck = $Decks/BuildDeck1
@onready var build_deck_2: Deck = $Decks/BuildDeck2
@onready var build_deck_3: Deck = $Decks/BuildDeck3
@onready var build_deck_4: Deck = $Decks/BuildDeck4


# `TableauDeck`s
@onready var tableau_deck_1: Deck = $Decks/TableauDeck1
@onready var tableau_deck_2: Deck = $Decks/TableauDeck2
@onready var tableau_deck_3: Deck = $Decks/TableauDeck3
@onready var tableau_deck_4: Deck = $Decks/TableauDeck4
@onready var tableau_deck_5: Deck = $Decks/TableauDeck5
@onready var tableau_deck_6: Deck = $Decks/TableauDeck6
@onready var tableau_deck_7: Deck = $Decks/TableauDeck7


# `Win Screen`
@onready var win_screen: Control = $WinScreen


# This contains all cards that are picked up as a group from a tableau deck
# this functionality doesn't come in the card plugin, so we have to manage it custom
# this will contain multuple cards picked of from a tableau deck at one time
var held_card_pile : Array = []


# start it up boi!
func _ready() -> void:
	_init_and_shuffle()
	_deal()
	_add_listeners()
	

# create Card scenes from CardData resources and shuffle
func _init_and_shuffle():
	for card_data in all_cards:
		var card = draw_pile.create_from_card_data(card_data)
		card.set_flipped(true)
	draw_pile.shuffle()


# deal cards to each tableau
func _deal():
	for i in range(1):
		draw_pile.move_card_to_deck(tableau_deck_1, draw_pile.get_top_card())
	tableau_deck_1.get_top_card().set_flipped(false)
	
	for i in range(2):
		draw_pile.move_card_to_deck(tableau_deck_2, draw_pile.get_top_card())
	tableau_deck_2.get_top_card().set_flipped(false)

	for i in range(3):
		draw_pile.move_card_to_deck(tableau_deck_3, draw_pile.get_top_card())
	tableau_deck_3.get_top_card().set_flipped(false)
		
	for i in range(4):
		draw_pile.move_card_to_deck(tableau_deck_4, draw_pile.get_top_card())
	tableau_deck_4.get_top_card().set_flipped(false)
		
	for i in range(5):
		draw_pile.move_card_to_deck(tableau_deck_5, draw_pile.get_top_card())
	tableau_deck_5.get_top_card().set_flipped(false)
		
	for i in range(6):
		draw_pile.move_card_to_deck(tableau_deck_6, draw_pile.get_top_card())
	tableau_deck_6.get_top_card().set_flipped(false)
		
	for i in range(7):
		draw_pile.move_card_to_deck(tableau_deck_7, draw_pile.get_top_card())
	tableau_deck_7.get_top_card().set_flipped(false)


# add all event listeners
func _add_listeners():
	
	back_button.connect('pressed', func(): get_tree().change_scene_to_file("res://example.tscn"))
	
	refresh_button.connect('pressed', _on_refresh_pressed)
	
	draw_pile.connect('top_card_clicked', _on_draw_pile_clicked)
	
	discard.connect('card_dropped', _card_dropped_from_discord)
	
	# these different nodes all use the same connected methods
	# so we bind the deck that was dropped so we have access to that in the connected method
	tableau_deck_1.connect('card_dropped', _card_dropped_from_tableau_deck.bind(tableau_deck_1))
	tableau_deck_2.connect('card_dropped', _card_dropped_from_tableau_deck.bind(tableau_deck_2))
	tableau_deck_3.connect('card_dropped', _card_dropped_from_tableau_deck.bind(tableau_deck_3))
	tableau_deck_4.connect('card_dropped', _card_dropped_from_tableau_deck.bind(tableau_deck_4))
	tableau_deck_5.connect('card_dropped', _card_dropped_from_tableau_deck.bind(tableau_deck_5))
	tableau_deck_6.connect('card_dropped', _card_dropped_from_tableau_deck.bind(tableau_deck_6))
	tableau_deck_7.connect('card_dropped', _card_dropped_from_tableau_deck.bind(tableau_deck_7))
	tableau_deck_1.connect('card_picked_up', _card_picked_up_from_tableau_deck.bind(tableau_deck_1))
	tableau_deck_2.connect('card_picked_up', _card_picked_up_from_tableau_deck.bind(tableau_deck_2))
	tableau_deck_3.connect('card_picked_up', _card_picked_up_from_tableau_deck.bind(tableau_deck_3))
	tableau_deck_4.connect('card_picked_up', _card_picked_up_from_tableau_deck.bind(tableau_deck_4))
	tableau_deck_5.connect('card_picked_up', _card_picked_up_from_tableau_deck.bind(tableau_deck_5))
	tableau_deck_6.connect('card_picked_up', _card_picked_up_from_tableau_deck.bind(tableau_deck_6))
	tableau_deck_7.connect('card_picked_up', _card_picked_up_from_tableau_deck.bind(tableau_deck_7))


# hide the clicked button and reset the discard Deck into the draw pile Deck
func _on_refresh_pressed():
	refresh_button.hide()
	for card in discard.get_child_count():
		var top_card = discard.get_top_card()
		top_card.set_flipped(true)
		discard.move_card_to_deck(draw_pile, top_card)


# move the top card from the draw_pile into the discard Deck
# it only does 1 card instead of 3 because it is much easier to win 1 at a time
# after drawing, if the draw pile Deck is empty, show the refresh button
func _on_draw_pile_clicked(_card : PlayingCard):
	for i in range(1):
		var top_card = draw_pile.get_top_card()
		if top_card:
			draw_pile.move_card_to_deck(discard, top_card)
			top_card.set_flipped(false)
	if draw_pile.get_child_count() == 0 and discard.get_child_count() != 0:
		refresh_button.show()

# when a card is dropped from discard there are 2 legal moves:
# 1) it is dropped on a legal tableu deck, so move it there
# 2) it is droppdd on a legal build deck, so move it there
func _card_dropped_from_discord(card : Card, dropped_on_deck : Deck):
	if dropped_on_deck is TableauDeck and dropped_on_deck.can_hold_card(card):
		discard.move_card_to_deck(dropped_on_deck, card)
	if dropped_on_deck is BuildDeck and dropped_on_deck.can_hold_card(card):
		dropped_on_deck.play_card(card)
		_check_for_win()


# when a card is dropped from a tableu deck there are 2 legal moves
# 1) it is dropped on a legal tableau deck, so move all held cards to the new deck and flip the next card
# 2_ it is dropped on a legal build deck, so move the 1 held card to the build deck, flip the next card, and check for a win
func _card_dropped_from_tableau_deck(card : Card, dropped_on_deck : Deck, dropped_from_deck : Deck):
	if dropped_on_deck is TableauDeck: 
		if dropped_from_deck != dropped_on_deck and dropped_on_deck.can_hold_card(card):
			for _card in held_card_pile:
				dropped_from_deck.move_card_to_deck(dropped_on_deck, _card)
			var top_card = dropped_from_deck.get_top_card()
			if top_card:
				top_card.set_flipped(false)
	if dropped_on_deck is BuildDeck and held_card_pile.size() == 1 and dropped_on_deck.can_hold_card(card):
		dropped_on_deck.play_card(card)
		var top_card = dropped_from_deck.get_top_card()
		if top_card:
			top_card.set_flipped(false)
		_check_for_win()
		
	# whether a legal move happens or not, if cards were dropped after being held from a tableu deck
	# we need to allow them to be autopositioned and empty our held card pile
	for c in held_card_pile:
		c.z_index = 0
		c.set_auto_position_enabled(true)
	held_card_pile = []


# if all build decks have 13 cards then the player wins! weee
func _check_for_win():
	if build_deck_1.get_child_count() == 13 and build_deck_2.get_child_count() == 13 and build_deck_3.get_child_count() == 13 and build_deck_4.get_child_count() == 13:
		win_screen.show()
	

# when a card is picked off a tableau deck we want to disable auto position in lieu of custom handling
# so collect the picked up card and all cards below it into the `held_card_pile` 
func _card_picked_up_from_tableau_deck(card: Card, from_deck : Deck):
	held_card_pile = from_deck.get_children().slice(card.get_index())
	for index in held_card_pile.size():
		var _card = held_card_pile[index]
		_card.z_index = 1 + index
		_card.set_auto_position_enabled(false)


# if there is a held card pile then we want to manually set their positions since auto position is disabled on them
func _process(_delta: float) -> void:
	if held_card_pile.size():
		for index in held_card_pile.size():
			var card = held_card_pile[index]
			var target_pos = get_global_mouse_position() - card.size * 0.5
			target_pos.y += card.get_parent().y_spread * index
			card.global_position = target_pos
