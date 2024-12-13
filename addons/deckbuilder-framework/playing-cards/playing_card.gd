class_name PlayingCard extends Card

enum STATES {
	IDLE,
	HOVERED,
	SELECTED
}

@onready var backface: TextureRect = $Textures/Backface
@onready var frontface: TextureRect = $Textures/Frontface
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var flipped := false

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

func play_animation(name : String) -> void:
	animation_player.play(name)
