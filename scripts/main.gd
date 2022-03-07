extends Node

@export var asteroidScene: PackedScene
@export var laserScene: PackedScene

signal deleteAsteroids

# actual vocab. Also lol this is the only comment. Sucks for you future me
var vocab = {
	"The Aenid": "An epic poem written by Virgil to explain the origin of Rome. This story tells of Rome being founded by a hero, named Aeneas. However, it was commisioned hundreds of years after Rome was founded.",
	"Romulus and Remus": "The traditional origin story of Rome. Two brothers, Romulus and Remus, were sent down the Tiber River to die. A she-wolf rescued them, and they planned to make a city in the spot where they were rescued. Romulus ended up accidentally killing his brother, and the city was ultimately named Rome.",
	"Cincinnatus": "A dictator from early Rome. The Romans belived he was a good leader because he didn't have a desire to lead. He successfully defeated an enemy Rome was at war with, and then stepped down to go back to his farm.",
	"Republic": "A system of government where people elect leaders to govern them.",
	"Dictator": "Rulers with almost absolute power. Rome elected these in six-month terms during times of war.",
	"Gracchus Brothers": "Two tribune brothers, Tiberius and Gaius, who wanted to build farms for poor Romans on public land. They were both killed in riots over this decision, and advanced the view of violence as a political message.",
	"Etruscans": "The people who settled the land north of Rome. Three of Rome's early kings were Etruscan. They made many parts of Rome's infrastructure, and advanced the Roman's way of thinking about the alphabet and numbers.",
	"Plebeians": "The common people of Rome. They were traders, merchants, artisans, or workers. At first, they could not have members in the government.",
	"Tribunes": "An office elected, and eventually held, by plebeians. Members stayed in office for one year, and could veto laws.",
	"Patricians": "The noble class of Rome. These people could hold almost any position in the Roman government.",
	"Twelve Tables": "Twelve bronze tablets inscribed with Rome's law. They were publicly viewable in the Forum.",
	"Assemblies": "Elections that chose the magistrates of Rome. Patricians and Plebeians could participate.",
	"Praetor": "Magistrates that interpreted the law and ruled over court cases.",
	"Magistrates": "Elected officials in Rome. These included the consuls, the praetors, and several others.",
	"Forum": "The Roman public meeting place. The Twelve Tables were placed here.",
	"Consuls": "The most powerful magistrates in Rome. Two consuls were elected so one single person would not hold too much power. They ran the city and led the army.",
	"Senate": "A council of wealthy and powerful Romans who advised the consuls. They held 300 members who were elected for life.",
	"Checks and Balances": "A system where government officials restrict each other's power, in order to balance it out. Heavily employed in the United States government.",
	"Punic Wars": "A series of three wars between Rome and Carthage. Carthage tried to invade Rome twice, and failed. On the third time, Rome invaded Carthage and defeated them.",
	"Hannibal": "A general in the Second Punic War. Hannibal led his army up the west of the Mediterranean, and almost conquered Rome. However, when coming back to defend Carthage, he was defeated by an invading Roman force.",
	"Lucius Cornelius Sulla": "A consul in Rome. He started a civil war against Marius, and won. He then named himself dictator.",
	"Legion": "Groups of up to 6,000 soldiers. They were divided into groups of 100 soldiers, called centuries.",
	"Spartacus": "A gladiator who led thousands of slaves in their demands for freedom. He was ultimately killed, and the rebellion failed.",
	"Gaius Marius": "A consul who encouraged poor citizens to join the army. He was a good general, so the army was more loyal to him than to Rome. This gave Marius lots of power. He was eventally defeated by Lucius Cornelius Sulla."
}

var vocabKeys = vocab.keys()
var vocabValues = vocab.values()
var vocabLen = vocab.size()
var gameSpeed

var score = 0
var highscore = 0

var correctAsteroid
var correctNumber
var lastCorrectNumber
var otherNumbers
var laserExists = false
var gameOn = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	gameOver()

func gameOver():
	if score > highscore:
		highscore = score
	score = 0
	gameOn = false
	emit_signal("deleteAsteroids")
	$HUD.hide()
	$Score/Label.text = str(highscore)
	$"Main Menu".show()

func _on_laser_laserIsGone():
	laserExists = false

func _on_Asteroid_hitByLaser(number):
	laserExists = false
	if number == correctAsteroid:
		gameSpeed += 2
		score += 1
		newDefinition()
	else:
		gameOver()

# redo thingy
func newDefinition():
	$Player.speed = 4 * gameSpeed
	$Background/CPUParticles2D.initial_velocity_min = gameSpeed
	$Background/CPUParticles2D.initial_velocity_max = gameSpeed
	emit_signal("deleteAsteroids")
	while correctNumber == lastCorrectNumber:
		correctNumber = randi_range(0, vocabLen-1)
	lastCorrectNumber = correctNumber
	correctAsteroid = randi_range(0, 3)
	for i in range(0, 4):
		var asteroid = asteroidScene.instantiate()
		asteroid.speed = gameSpeed
		asteroid.number = i
		if i == correctAsteroid:
			asteroid.text = vocabKeys[correctNumber]
		else:
			var rng = randi_range(0, vocabLen-1)
			otherNumbers = []
			while rng == correctNumber or otherNumbers.has(rng):
				rng = randi_range(0, vocabLen-1)
			otherNumbers.append(rng)
			asteroid.text = vocabKeys[rng]
		asteroid.position.x = 60 + i*120
		asteroid.hitByLaser.connect(_on_Asteroid_hitByLaser)
		asteroid.gameOver.connect(gameOver)
		deleteAsteroids.connect(asteroid._on_main_deleteAsteroids)
		add_child(asteroid)
	$HUD/Definition/Label.text = vocabValues[correctNumber]
	$Score/Label.text = str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("fire") and gameOn and not laserExists:
		laserExists = true
		var laser = laserScene.instantiate()
		laser.speed = gameSpeed * 2
		laser.position.x = $Player.position.x
		laser.position.y = $Player.position.y
		deleteAsteroids.connect(laser._on_main_deleteAsteroids)
		laser.laserIsGone.connect(_on_laser_laserIsGone)
		add_child(laser)


func _on_main_menu_clicked_play():
	gameSpeed = 100
	gameOn = true
	$HUD.show()
	newDefinition()
