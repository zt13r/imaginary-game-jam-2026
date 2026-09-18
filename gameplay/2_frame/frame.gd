class_name Frame
extends Resource


enum Type {
	EXECUTION,
	DECISION
}


@export var type : Type = Type.EXECUTION

@export var texture : Texture2D = null
@export var background : Texture2D = null
