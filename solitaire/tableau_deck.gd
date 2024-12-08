class_name TableauDeck extends Deck

# check if a card can be played on this deck
func can_hold_card(card : PlayingCard):
	if get_child_count() == 0:
		return card.card_data.value == 13
	else:
		var top_card = get_top_card()
		if top_card.card_data.value == card.card_data.value + 1: 
			if top_card.card_data.suit == PlayingCardData.SUITS.CLUBS or top_card.card_data.suit == PlayingCardData.SUITS.SPADES:
				return card.card_data.suit == PlayingCardData.SUITS.DIAMONDS or card.card_data.suit == PlayingCardData.SUITS.HEARTS
			elif top_card.card_data.suit == PlayingCardData.SUITS.DIAMONDS or top_card.card_data.suit == PlayingCardData.SUITS.HEARTS:
				return card.card_data.suit == PlayingCardData.SUITS.CLUBS or card.card_data.suit == PlayingCardData.SUITS.SPADES
	return false

# run a custom function to see if a card can be picked up from this deck
# the plugin only supports none/all/top natively but we want to allow any /flipped/ card to be picked up
func custom_can_card_be_dragged(card : Card):
	return card.flipped == false
