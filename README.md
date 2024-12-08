# Deckbuilder Framework

This system implements card and deck mechanics in Godot Engine. It features drawing, shuffling, and many more standard card behaviors and interactions. A standard deck of playing cards comes packaged with this plugin, but it can really be used for any time of cards. 

## Table of Contents
- [Quick Example](#quick-example)
- [Installation](#instalation)
- [Getting Started](#getting-started)
- [Components](#components)
  - [CardData](#card-data)
  - [Card](#card)
  - [Deck](#deck)


<a href="#quick-example"></a>
## Quick Example
```
var cards = [
  preload("res://path/to/your/card1.tres"),
  preload("res://path/to/your/card2.tres"),
  preload("res://path/to/your/card3.tres")
]

@onready var draw_pile: Deck = $DrawPile
@onready var hand: Deck = $Hand

func _ready():
  for data in cards:
	draw_pile.create_from_card_data(data)
  draw_pile.shuffle()
  draw_pile.move_card_to_deck(hand, draw_pile.get_top_card())

```

<a href="#installation"></a>
## Installation
1. Download the latest release
2. Unpack the `addons/deckbuilder-framwork` into your `/addons` folder within the Godot project

<a href="#getting-started"></a>
## Getting Started
1. Extend the `CardData` resource script with any data your cards will need
2. Create a `Card` scene that implements your `CardData`
3. Add a `Deck` into your game
4. Create cards in the deck using the `create_from_card_data` method
5. Connect the signals decks emit and use them make mange your game

<a href="#computed"></a>
## Components

<a href="#card-data"></a>
### `CardData`
Resource data. Generally this data will initialize your `Card` scene. After you setup your `CardData` you can create your card resources (.tres files) that use this as their script.

#### Example
```
# playing_card.gd

class_name PlayingCardData extends CardData

enum SUITS {
	SPADES,
	CLUBS,
	DIAMONDS,
	HEARTS
}

@export var suit : SUITS
@export var value : int
@export var back_image : Resource
@export var front_image : Resource
```

After setting this up you create your card resources as needed (`spades-a.tres`, `spades-2.tres`, `spades-3.tres`, etc.).

The only requirement here is that you also provide it a `card_scene` `PackedScene` which will be explained next.

<a href="#card"></a>
### `Card`
A root node scene. Create your in-game card scene by using this as the root node. Generally this changes its display using it's `card_data` in the `update_display` method.

#### Public Methods:

`set_card_data(card_data : CardData) -> void` 

Set this scenes card data and updates the display.

`set_auto_position_enabled(val : bool) -> void` 

Turns on/off autopositioning. This is helpful if you want the card in a deck but you also want to manually position the card somewhere else in the game world.

`update_display() -> void`

Manually update the card display. This is automatically called on `_ready` but you may also want to call it manually when one of the `Cards`'s `card_data` properties change.

#### Example
```
# playing_card.tscn
class_name PlayingCard extends Card

@onready var backface: TextureRect = $Backface
@onready var frontface: TextureRect = $Frontface

func update_display():
	backface.texture = card_data.back_image
	frontface.texture = card_data.front_image

```

<a id="deck"></a>
### `Deck`
A control node that manages a stack of cards. This is the main node your game will interact with and listen for signals on. 

At first listening for signals on the deck instead of on the card may seem unintuitive but this allows you to easily manage different interactions on cards on different decks. For example, your game shouldn't necessarily listen for a mouse entered signal on an individual card scene, it should listen for the deck signaling that a card within it has had the mouse enter it. 

#### Signals
- `mouse_entered_card(card : Card)`
- `mouse_exited_card(card : Card)`
- `top_card_clicked(card : Card)`
- `card_clicked(card : Card)`
- `card_picked_up(card : Card)`
- `card_dropped(card : Card)`
- `card_dropped_on_deck(card : Card, from_deck : Deck)`
- `cards_updated`

#### Exported Variables
- `x_spread`: float – Horizontal spread of cards in the deck
- `y_spread`: float – Vertical spread of cards in the deck
- `max_stack_size`: int – Maximum number of cards displayed in a stacked
- `drag_behavior`: DRAG_BEHAVIOR – Dragging policy (NONE, ALL, TOP, CUSTOM).
- `stack_behavior`: STACK_BEHAVIOR – Stacking policy (EXACT, CENTERED).
- `hand_rotation_curve`: Curve – Rotation curve for hands. This works best as a 2-point linear rise from -X to +X
- `hand_vertical_curve`: Curve – Vertical curve for hands. This works best as a 3-point ease in/out from 0 to X to 0

#### Public methods

`create_from_card_data(card_data: CardData) -> Card`

Creates a new card instance based on the provided CardData and adds it to the deck.

```
var card_data = load("res://path/to/card_data.tres")
var new_card = deck.create_from_card_data(card_data)
```

`move_card_to_deck(deck: Deck, card: Card)`

Moves a card from one deck to another

```
deck1.move_card_to_deck(deck2, card)
```

`shuffle() -> void`

Randomizes the order of cards in the deck.

```
deck.shuffle()
```

`get_top_card() -> Card`

Retrieves the top card of the deck without removing it.

```
var top_card = deck.get_top_card()
if top_card:
	print("Top card is:", top_card, top_card.card_data)
```

`custom_can_card_be_dragged(card: Card) -> bool`

Determines whether a specified card can be dragged. This method is intended to be overridden for custom dragging behavior when `drag_behavior` is set to `DRAG_BEHAVIOR.CUSTOM`

```
func custom_can_card_be_dragged(card: Card) -> bool:
	return card.card_data.some_value >= 3
```

---
