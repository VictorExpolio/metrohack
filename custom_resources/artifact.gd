class_name Artifact
extends Resource

enum Type {START_OF_TURN, START_OF_COMBAT, END_OF_TURN, END_OF_COMBAT, EVENT_BASED}
enum CharacterType {ALL, WARRIOR, ANT, VIPER}

@export var artifact_name : String
@export var id : String
@export var type: Type
@export var character_type: CharacterType
@export var starter_artifact: bool = false
@export var icon: Texture
@export var shop_cost : int
@export_multiline var tooltip: String
@export_multiline var flavour_tooltip: String

func initialize_artifact(_owner: ArtifactUI) -> void:
	pass

func activate_artifact(_owner: ArtifactUI) -> void:
	pass

#for EVENT type artifacts, and for artifacyts removed
func deactivate_artifact(_owner: ArtifactUI) -> void:
	pass

func get_tooltip() -> String:
	return tooltip

func can_apper_as_reward(character: CharacterStats) -> bool:
	if starter_artifact:
		return false
	if character_type == CharacterType.ALL:
		return true
	
	#comparamos si el nombre del tipo es igual al del personaje entonces puede aparecer
	var artifact_char_name: String = CharacterType.keys()[character_type].to_lower()
	var char_name := character.character_name.to_lower()
	
	return artifact_char_name == char_name
	
	
