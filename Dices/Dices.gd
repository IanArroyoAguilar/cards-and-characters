class_name Dice
extends Resource

@export var num_sides: int

static var D2: Dice
static var D4: Dice
static var D6: Dice
static var D8: Dice
static var D10: Dice
static var D12: Dice
static var D20: Dice
static var D100: Dice

# 2. Las inicializamos cuando el script se carga por primera vez
static func _static_init() -> void:
	D2 = Dice.new()
	D2.num_sides = 2

	D4 = Dice.new()
	D4.num_sides = 4

	D6 = Dice.new()
	D6.num_sides = 6

	D8 = Dice.new()
	D8.num_sides = 8

	D10 = Dice.new()
	D10.num_sides = 10

	D12 = Dice.new()
	D12.num_sides = 12

	D20 = Dice.new()
	D20.num_sides = 20

	D100 = Dice.new()
	D100.num_sides = 100
	
func roll(MOD: int = 0):
	return randi_range(1,num_sides) + MOD

static func get_dado_por_nombre(nombre: String) -> Dice:
	match nombre.to_upper():
		"D2": return D2
		"D4": return D4
		"D6": return D6
		"D8": return D8
		"D10": return D10
		"D12": return D12
		"D20": return D20
		"D100": return D100
		_: return null
