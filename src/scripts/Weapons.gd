extends Node


var current = -1
const MAX_UPGRADES = 3

enum {
	HAMMER,
	PISTOL,
	SHOTGUN,
	GRENADE,
	LASER,
	KATANA,
}

var names = [
	"Hammer",
	"Pistol",
	"Shotgun",
	"Grenade",
	"Laser",
	"Katana"
]

var upgrades = [
	0,
	0,
	0,
	0,
	0,
	0
	]

var buycost = [
	1.0,
	1.0,
	3.0,
	6.0,
	5.0,
	5.0
]

var upcost = [
	1.0,
	1.0,
	1.5,
	2.5,
	2.5,
	2.5
]
