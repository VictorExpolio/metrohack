# meta-name: Effect Logic
#meta-description: An effect is executed to a target
class_name MyEffect
extends Effect

var member_var : int = 0

func execute(targets : Array[Node]) -> void:
	print("My effect targets them:%" % targets)
	print("It does %s something" % member_var)
