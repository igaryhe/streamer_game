class_name Interactable
extends StaticBody3D

@export var expected_item_ids: Array[int]
@export var initial_score: float

func can_interact(item_id: int) -> bool:
	if expected_item_ids.is_empty():
		return true
	for id in expected_item_ids:
		if item_id == id:
			return true
	return false
