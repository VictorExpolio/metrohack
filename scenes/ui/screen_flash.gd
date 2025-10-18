extends CanvasLayer

@onready var red_color_rect: ColorRect = $RedColorRect
@onready var flash_timer: Timer = $FlashTimer

func _ready() -> void:
	Events.player_hurt.connect(_on_player_hurt)
	flash_timer.timeout.connect(_on_timer_timeout)

func _on_player_hurt() -> void:
	red_color_rect.color.a = 0.16
	flash_timer.start()

func _on_timer_timeout() -> void:
	red_color_rect.color.a = 0
