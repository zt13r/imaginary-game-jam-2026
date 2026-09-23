class_name Frame
extends Resource


enum Type {
	EXECUTION,
	#DECISION
}


@export var type : Type = Type.EXECUTION

@export var textures : Array[Texture2D] = []
@export var backgrounds : Array[Texture2D] = []
