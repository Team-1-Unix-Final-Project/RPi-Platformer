extends Camera2D

func _physics_process(_delta):
	position = global.player.get_global_position()
