extends Button

export (String) var price = "$0.0"
export (String) var weaponName = "weapon"

#click type
enum {
	LEFT,
	MIDDLE,
	RIGHT,
}

var click = -1
var n = 0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			click = LEFT
		elif event.button_index == BUTTON_RIGHT:
			click = RIGHT
		elif event.button_index == BUTTON_MIDDLE:
			click = MIDDLE
func _ready():
	update_price()
	click = LEFT
	find_node("WeaponName").set_text(weaponName)

func _on_Button_pressed():
	update_price()

func update_price():
	for w in range(6):
		if weaponName == Weapons.weaponnames[w][1]:
			find_the_n(Weapons.mprice[w][1], \
				Weapons.uprice[w][1])

func find_the_n(mprice: float, uprice: float):
	if click == LEFT and n < 3:
		n += 1
	elif click == RIGHT and n > 0:
		n -= 1

	if n == 0:
		find_node("Price").set_text("$" + str(mprice))
	elif n == 1:
		find_node("Price").set_text("$" + str(mprice + uprice * n))
	elif n == 2:
		find_node("Price").set_text("$" + str(mprice + uprice * n))
	elif n == 3:
		find_node("Price").set_text("$" + str(mprice + uprice * n))
	else:
		print("n more than 3")
