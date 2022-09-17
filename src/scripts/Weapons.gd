extends Node

#minimum prices
#var mhammer: float = 0.0
#var mpistol: float = 0.0
#var mshotgun: float = 3.0
#var mgrenedelauncher: float = 6.0
#var mlaser: float = 5.0
#var mkatana: float = 5.0


#upgrade prices
#var uhammer: float = 1.0
#var upistol: float = 1.0
#var ushotgun: float = 1.5
#var ugrenedelauncher: float = 2.5
#var ulaser: float = 2.5
#var ukatana: float = 2.5

enum {
	HAMMER,
	PISTOL,
	SHOTGUN,
	GRENEDEL,
	LASER,
	KATANA,
}

var weaponnames = [
	[HAMMER, "Hammer"], 
	[PISTOL, "Pistol"], 
	[SHOTGUN, "Shotgun"], 
	[GRENEDEL, "GrenedeLauncher"], 
	[LASER, "Laser"], 
	[KATANA, "Katana"]
	]

var mprice = [
	[HAMMER, 0.0], 
	[PISTOL, 0.0], 
	[SHOTGUN, 3.0], 
	[GRENEDEL, 6.0], 
	[LASER, 5.0], 
	[KATANA, 5.0]
	]

var uprice = [
	[HAMMER, 1.0], 
	[PISTOL, 1.0], 
	[SHOTGUN, 1.5], 
	[GRENEDEL, 2.5], 
	[LASER, 2.5], 
	[KATANA, 2.5]
	]
