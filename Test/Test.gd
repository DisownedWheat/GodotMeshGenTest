extends Spatial


class Mesher:
	var count = 0
	var uv = Vector2()
	var st = SurfaceTool.new()
	func add_vertex(vec):
		st.add_uv(uv)
		st.add_uv2(uv)
		st.add_vertex(vec)
		count += 1
		if uv.x == uv.y:
			uv.x += 1
		else:
			uv.y += 1

onready var mesher = Mesher.new()

func _ready():
	var test = Vector2()
	test += Vector2.ONE
	print(test)
	mesher.st.begin(Mesh.PRIMITIVE_TRIANGLES)
	randomize()
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 20.0
	noise.persistence = 0.8

	print("Values:")
	print(noise.get_noise_2d(1.0, 1.0))
	print(noise.get_noise_3d(0.5, 3.0, 15.0))
	print(noise.get_noise_4d(0.5, 1.9, 4.7, 0.0))

	var vector_array = Array()
	for x in range(0, 200):
		var this_array = PoolVector3Array()
		for z in range(0, 200):
			var n = noise.get_noise_2d(x, z)
			var y
			if n > 0:
				y = 1
			else:
				y = 0
			this_array.append(Vector3(x, y, z))

		vector_array.append(this_array)

	for i in range(0, len(vector_array) - 2):
		var vec = vector_array[i]
		for i2 in range(0, len(vec) - 2):
			var pos1 = vec[i2]
			var pos2 = vector_array[i + 1][i2]
			var pos3 = vec[i2 + 1]
			var pos4 = vector_array[i + 1][i2 + 1]
			mesher.add_vertex(pos1)
			mesher.add_vertex(pos2)
			mesher.add_vertex(pos3)

			mesher.add_vertex(pos2)
			mesher.add_vertex(pos4)
			mesher.add_vertex(pos3)
	mesher.st.index()

	mesher.st.generate_normals()
	print(mesher.count)
	print(mesher.count)
	mesher.st.generate_tangents()

	var m = mesher.st.commit()
	$MeshInstance.mesh = m
	$RigidBody/CollisionShape.shape = m.create_trimesh_shape()

