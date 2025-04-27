extends CollisionShape3D

@export var height_map_path: String
@export var height_min: float
@export var height_max: float

func _ready():
	var heightmap_texture = ResourceLoader.load(height_map_path)
	var heightmap_image = heightmap_texture.get_image()
	heightmap_image.convert(Image.FORMAT_RF)
	shape.update_map_data_from_image(heightmap_image, height_min, height_max)
