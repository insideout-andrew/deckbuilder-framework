class_name PlayingCard extends Card

@onready var backface: TextureRect = $Backface
@onready var frontface: TextureRect = $Frontface

var hovered = false
var flipped = false

func set_hovered(val : bool):
	if hovered != val:
		if val:
			target_position.y -= 15
		else:
			target_position.y += 15
		hovered = val

func set_flipped(val : bool):
	flipped = val
	update_display()

func update_display():
	if card_data:
		backface.texture = card_data.back_image
		frontface.texture = card_data.front_image
		if flipped:
			backface.show()
			frontface.hide()
		else:
			backface.hide()
			frontface.show()
