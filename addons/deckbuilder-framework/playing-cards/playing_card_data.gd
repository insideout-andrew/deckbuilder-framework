class_name PlayingCardData extends CardData

enum SUITS {
	SPADES,
	CLUBS,
	DIAMONDS,
	HEARTS,
	NONE
}

@export var suit : SUITS
@export var value : int
@export var back_image : Resource
@export var front_image : Resource
