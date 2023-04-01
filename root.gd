extends Node2D

const WINDOWS_WIDTH = 1280
const WINDOWS_HEIGHT = 960

const CONFIG_PATH = "res://seed_generation.cfg"

var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	var seed_master

	# If the file didn't load, ignore it.
	if err != OK:
		print("file non trovato, genero nuovo seed")
		seed_master = get_seed()
		print("seed generato:" + str(seed_master))
	else:
		seed_master = config.get_value("config", "seed")
		print("seed recuperato:" + str(seed_master))
	
	rng = RandomNumberGenerator.new()
	test(seed_master)

func get_seed():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err != OK:
		var seed = hash(Time.get_ticks_msec())
		config.set_value("config", "seed", seed)
		config.save(CONFIG_PATH)
		return seed
	return config.get_value("config", "seed")

func randomize_seed():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err != OK:
		return get_seed()
	var seed = hash(Time.get_ticks_msec())
	config.set_value("config", "seed", seed)
	config.save(CONFIG_PATH)
	return seed

func test(seed_master):
	rng.seed = (50 & 0xFFFF) << 16 | (50 & 0xFFFF) + seed_master
	print("x:50 y:50 is_star: " + str(is_star()))
	rng.seed = (968 & 0xFFFF) << 16 | (956 & 0xFFFF) + seed_master
	print("x:968 y:956 is_star: " + str(is_star()))

func is_star():
	return rng.randi_range(0, 100) < 32

func _input(event):
	if event.is_action_pressed("ui_filedialog_refresh"):
		print("queue_redraw")
		test(randomize_seed())
