# meta-name: Status Logic
#meta-description: Status applied to any target
class_name MyCustomStatus
extends Status

var member_var := 0

func initialize_status(target: Node) -> void:
	print("Initialize status %s" % target)

func apply_status(target: Node) -> void:
	print("Initialize status %s" % target)
	print("It does THIS %s thing amount" % member_var)
	
	status_applied.emit(self)
