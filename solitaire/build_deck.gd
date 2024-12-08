class_name BuildDeck extends Deck

# keep track of which suit was first played on this deck
var suit : PlayingCardData.SUITS = PlayingCardData.SUITS.NONE

# keep track of thet last played card on this deck
var required_value : int = 1

# check if this deck can hold a given card
func can_hold_card(card : PlayingCard):
	if suit == PlayingCardData.SUITS.NONE:
		return card.card_data.value == required_value
	else:
		return suit == card.card_data.suit && card.card_data.value == required_value

# play a card on this deck and update the required value
func play_card(card : Card):
	if suit == PlayingCardData.SUITS.NONE:
		suit = card.card_data.suit
	var card_parent : Deck = card.get_parent()
	card_parent.move_card_to_deck(self, card)
	required_value += 1
