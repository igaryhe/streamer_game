extends Interactable
# 0 for eyes
# 1 for hands
# 2 for legs
@export var parts: int

func interact(item_id: int):
	print("interacting with " + str(item_id) + ", " + str(parts))
