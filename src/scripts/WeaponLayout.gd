extends Button

export (String) var price = "$0.0"
export (String) var weaponName = "weapon"

#click type
enum {
	LEFT,
	MIDDLE,
	RIGHT,
}

var p: float = 0.0
var click: int = -1
var n: int = 0
var w: int = -1
var has_me: bool = false
var prev_cost: float = 0.0



func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			click = LEFT
		elif event.button_index == BUTTON_RIGHT:
			click = RIGHT
		elif event.button_index == BUTTON_MIDDLE:
			click = MIDDLE
func _ready():
	get_weapon()
	update_status()
	find_node("WeaponName").set_text(weaponName)

func _on_Button_pressed():
	update_status()

func get_weapon():
	for W in range(6):
		if Weapons.names[W] == weaponName:
			w = W
			continue

func update_status():
	if click == LEFT and !has_me:
		buy_weapon()
	elif click == LEFT and n < (Weapons.MAX_UPGRADES):
		buy_upgrade()
		Weapons.upgrades[w] += 1
	elif click == RIGHT and n > 0:
		sell_upgrade()
		Weapons.upgrades[w] -= 1
	elif click == RIGHT and has_me:
		sell_weapon()

	if !has_me:
		modulate = Color(0.5, 0.5, 0.5)
		p = Weapons.buycost[w]
		find_node("Price").set_text("$" + str(p))
	elif n <= Weapons.MAX_UPGRADES:
		modulate = Color(1, 1, 1)
		p = Weapons.upcost[w]
		find_node("Price").set_text("$" + str(p))
	else:
		print("n more than" + str(Weapons.MAX_UPGRADES))

	find_node("Upgrades").text = "upgrades " + str(n) + "/" + str(Weapons.MAX_UPGRADES)

func sell_weapon():
	has_me = false
	Weapons.current = -1
	p = Weapons.buycost[w]
	Globals.currency += p
	print("selling " + str(Weapons.names[w]) + \
		" of " + str(Weapons.upgrades[w]) + " upgrades " + \
		"that costs " + str(p))

func sell_upgrade():
	p = Weapons.upcost[w]
	Globals.currency += p
	n -= 1
	print("selling upgrade " + str(Weapons.names[w]) + \
		" of " + str(Weapons.upgrades[w]) + " upgrades " + \
		"that costs " + str(p))


func buy_weapon():
	if Weapons.current == -1:
		Weapons.current = w
		has_me = true
		p = Weapons.buycost[w]
		if Globals.currency > p:
			Globals.currency -= p
		print("buying " + str(Weapons.names[w]) + \
			" of " + str(Weapons.upgrades[w]) + " upgrades " + \
			"that costs " + str(p))

func buy_upgrade():
	p = Weapons.upcost[w]
	if Globals.currency > p:
		Globals.currency -= p
		n += 1
	print("buying upgrade" + str(Weapons.names[w]) + \
		" of " + str(Weapons.upgrades[w]) + " upgrades " + \
		"that costs " + str(p))

func calc_cost(has_me: bool):
	if !has_me:
		return Weapons.buycost[w]
	return Weapons.upcost[w]
