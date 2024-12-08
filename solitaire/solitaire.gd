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
	
	build_deck_1.connect('card_dropped_on_deck', _card_dropped_on_build_deck.bind(build_deck_1))
	build_deck_2.connect('card_dropped_on_deck', _card_dropped_on_build_deck.bind(build_deck_2))
	build_deck_3.connect('card_dropped_on_deck', _card_dropped_on_build_deck.bind(build_deck_3))
	build_deck_4.connect('card_dropped_on_deck', _card_dropped_on_build_deck.bind(build_deck_4))

	tableau_deck_1.connect('card_dropped_on_deck', _card_dropped_on_tableau_deck.bind(tableau_deck_1))
	tableau_deck_2.connect('card_dropped_on_deck', _card_dropped_on_tableau_deck.bind(tableau_deck_2))
	tableau_deck_3.connect('card_dropped_on_deck', _card_dropped_on_tableau_deck.bind(tableau_deck_3))
	tableau_deck_4.connect('card_dropped_on_deck', _card_dropped_on_tableau_deck.bind(tableau_deck_4))
	tableau_deck_5.connect('card_dropped_on_deck', _card_dropped_on_tableau_deck.bind(tableau_deck_5))
	tableau_deck_6.connect('card_dropped_on_deck', _card_dropped_on_tableau_deck.bind(tableau_deck_6))
	tableau_deck_7.connect('card_dropped_on_deck', _card_dropped_on_tableau_deck.bind(tableau_deck_7))

	tableau_deck_1.connect('card_dropped', _card_dropped_from_tableau_deck)
	tableau_deck_2.connect('card_dropped', _card_dropped_from_tableau_deck)
	tableau_deck_3.connect('card_dropped', _card_dropped_from_tableau_deck)
	tableau_deck_4.connect('card_dropped', _card_dropped_from_tableau_deck)
	tableau_deck_5.connect('card_dropped', _card_dropped_from_tableau_deck)
	tableau_deck_6.connect('card_dropped', _card_dropped_from_tableau_deck)
	tableau_deck_7.connect('card_dropped', _card_dropped_from_tableau_deck)

	tableau_deck_1.connect('card_picked_up', _card_picked_up_on_tableau_deck.bind(tableau_deck_1))
	tableau_deck_2.connect('card_picked_up', _card_picked_up_on_tableau_deck.bind(tableau_deck_2))
	tableau_deck_3.connect('card_picked_up', _card_picked_up_on_tableau_deck.bind(tableau_deck_3))
	tableau_deck_4.connect('card_picked_up', _card_picked_up_on_tableau_deck.bind(tableau_deck_4))
	tableau_deck_5.connect('card_picked_up', _card_picked_up_on_tableau_deck.bind(tableau_deck_5))
	tableau_deck_6.connect('card_picked_up', _card_picked_up_on_tableau_deck.bind(tableau_deck_6))
	tableau_deck_7.connect('card_picked_up', _card_picked_up_on_tableau_deck.bind(tableau_deck_7))



# hide the clicked button and reset the discard Deck into the draw pile Deck
func _on_refresh_pressed():
	refresh_button.hide()
	for card in discard.get_child_count():
		var top_card = discard.get_top_card()
		top_card.set_flipped(true)
		discard.move_card_to_deck(draw_pile, top_card)	


# move the top 1 or 3 cards into the discard Deck
# 1 card is easier - so that is what I'm doing - but easy to switch
# if the draw pile Deck is empty, show the refresh button
func _on_draw_pile_clicked(_card : PlayingCard):
	for i in range(1):
		var top_card = draw_pile.get_top_card()
		if top_card:
			draw_pile.move_card_to_deck(discard, top_card)
			top_card.set_flipped(false)
	if draw_pile.get_child_count() == 0 and discard.get_child_count() != 0:
		refresh_button.show()


# when a card is dropped on a BuildDeck
# if is is a legal play there are two options
# 1) it came from discard deck - so simply move it ot the build deck
# 2) it come from a tableau deck - so make sure the held pile is only a single card, then move it and flip the top card of the tableau deck it came from
# then check if the player won the game
func _card_dropped_on_build_deck(card : PlayingCard, from_deck : Deck, build_deck : BuildDeck):
	if build_deck.can_hold_card(card):
		if from_deck == discard:
			build_deck.play_card(card)
		elif held_card_pile.size() == 1:
			build_deck.play_card(card)
			if from_deck is TableauDeck:
				var top_card = from_deck.get_top_card()
				if top_card:
					top_card.set_flipped(false)
		if build_deck_1.get_child_count() == 13 and build_deck_2.get_child_count() == 13 and build_deck_3.get_child_count() == 13 and build_deck_4.get_child_count() == 13:
			win_screen.show()


# when a card is dropped on a TableauDeck
# if it is a legal play there are two options
# 1) it came from discard deck - so simply move it to the tableau
# 2) move all cards from the held_card_pile on top of the TableauDeck, then flip the top card from the TableauDeck they came from
func _card_dropped_on_tableau_deck(card : PlayingCard, from_deck : Deck, tableau_deck : TableauDeck):
	if from_deck != tableau_deck and tableau_deck.can_hold_card(card):
		if from_deck == discard:
			from_deck.move_card_to_deck(tableau_deck, card)
		else:
			for _card in held_card_pile:
				from_deck.move_card_to_deck(tableau_deck, _card)
			var top_card = from_deck.get_top_card()
			if top_card:
				top_card.set_flipped(false)


# when a card is in a tableau deck and dropped anywhere (this should be done whether the card was dropped on a deck or on nothing)
# reset the z_index
# allow auto position again
# reset the held_card_pile
func _card_dropped_from_tableau_deck(_card : Card):
	for card in held_card_pile:
		card.z_index = 0
		card.set_auto_position_enabled(true)
	held_card_pile = []


# when a card is picked off a tableau deck we want to disable auto position in lieu of custom handling
# so collect the picked up card and all cards below it into the `held_card_pile` 
func _card_picked_up_on_tableau_deck(card: Card, from_deck : Deck):
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
