tool
extends Control


var AtlasParser = preload("atlas.gd")
var FrameItem = preload("frame_item.tscn")
onready var dialog = get_node("Dialog")
onready var listbox = dialog.get_node("Preview/Background/ScrollContainer/VBox")
var fileDialog = FileDialog.new()

const SEL_INPUT_META = 0;
const SEL_OUTPUT_TEX = 1;
var current_dialog = -1;

signal confim_import(path, meta)

func _ready():
	fileDialog.connect("file_selected", self, "_fileSelected")
	add_child(fileDialog)

	dialog.get_ok().set_text("Import")
	dialog.get_node("Input/Source/Browse").connect("pressed", self, "_selectMetaFile")
	dialog.get_node("Input/Target/Browse").connect("pressed", self, "_selectTargetFile")
	dialog.get_node("Input/Target/TargetDirField").connect("text_changed", self, "_checkPath")
	dialog.get_node("Input/Source/MetaFileField").connect("text_changed", self, "_checkPath")
	dialog.get_node("Input/Type/TypeButton").connect("item_selected", self, "_typeSelected")
	dialog.get_node("Input/Compress/TypeButton").connect("item_selected", self, "_typeSelected")
	dialog.get_node("Input/Compress/Quality/Slider").connect("value_changed", self, "_changeQuality")
	dialog.get_node("Input/Type/TypeButton").select(0)
	dialog.connect("confirmed", self, "_confirmed")
	dialog.set_pos(Vector2(get_viewport_rect().size.width/2 - dialog.get_rect().size.width/2, get_viewport_rect().size.height/2 - dialog.get_rect().size.height/2))
	# dialog.show()

func _typeSelected(id):
	_checkPath("")

func _changeQuality(value):
	get_node("Dialog/Input/Compress/Quality/Value").set_text(str(value))

func _showFileDialog():
	fileDialog.set_custom_minimum_size(dialog.get_size() - Vector2(50, 50))
	fileDialog.set_pos(dialog.get_pos() + Vector2(25, 50))

	var file = File.new()
	if fileDialog.get_access() == FileDialog.ACCESS_FILESYSTEM:
		var path = dialog.get_node("Input/Source/MetaFileField").get_text()
		if file.file_exists(path):
			fileDialog.set_current_dir(_getParentDir(path))
	fileDialog.popup()
	fileDialog.invalidate()

func _selectMetaFile():
	current_dialog = SEL_INPUT_META
	fileDialog.clear_filters()
	var curtype = dialog.get_node("Input/Type/TypeButton").get_selected_ID()
	if curtype in [AtlasParser.FORMAT_TEXTURE_PACKER_XML, AtlasParser.FORMAT_KENNEY_SPRITESHEET]:
		fileDialog.add_filter("*.xml")
	elif curtype in [AtlasParser.FORMAT_TEXTURE_JSON, AtlasParser.FORMAT_ATTILA_JSON]:
		fileDialog.add_filter("*.json")
	fileDialog.set_access(FileDialog.ACCESS_FILESYSTEM)
	fileDialog.set_mode(FileDialog.MODE_OPEN_FILE)
	_showFileDialog()

func _selectTargetFile():
	current_dialog = SEL_OUTPUT_TEX
	fileDialog.clear_filters()
	fileDialog.add_filter("*.tex")
	fileDialog.add_filter("*.res")
	fileDialog.set_mode(FileDialog.MODE_SAVE_FILE)
	fileDialog.set_access(FileDialog.ACCESS_RESOURCES)
	var resetname = _getFileName(dialog.get_node("Input/Source/MetaFileField").get_text())
	if resetname == null:
		resetname = ""
	fileDialog.set_current_file(str(resetname,".tex"))
	_showFileDialog()

func _fileSelected(path):
	if current_dialog == SEL_INPUT_META:
		dialog.get_node("Input/Source/MetaFileField").set_text(path)
	elif current_dialog == SEL_OUTPUT_TEX:
		dialog.get_node("Input/Target/TargetDirField").set_text(path)
	_checkPath("")

func _getParentDir(path):
	var fileName = path.substr(0, path.find_last("/"))
	return fileName

func _getFileName(path):
	var fileName = path.substr(path.find_last("/")+1, path.length() - path.find_last("/")-1)
	var dotPos = fileName.find_last(".")
	if dotPos != -1:
		fileName = fileName.substr(0,dotPos)
	return fileName

func _checkPath(path):
	# Clear preview list
	for c in listbox.get_children():
		listbox.remove_child(c)
	listbox.update()
	
	# Show/Hide qulity controls
	var quality_node = get_node("Dialog/Input/Compress/Quality")
	if get_node("Dialog/Input/Compress/TypeButton").get_selected() == ImageTexture.STORAGE_COMPRESS_LOSSY:
		quality_node.show()
	else:
		quality_node.hide()
	
	# Check input file
	var file = File.new()
	var inpath = dialog.get_node("Input/Source/MetaFileField").get_text()
	if file.file_exists(inpath):
		if not _updatePreview(inpath):
			dialog.get_node("Status").set_text("No frame found")
			return false
	else:
		dialog.get_node("Status").set_text("Source meta file does not exists")
		return false
	
	# Check output file
	var tarfile = dialog.get_node("Input/Target/TargetDirField").get_text()
	if tarfile.substr(0, "res://".length()) != "res://":
		dialog.get_node("Status").set_text("Target file must under res://")
		return false
	# Check passed
	dialog.get_node("Status").set_text("")
	return true

func _loadAtlas(metaPath, format):
	var atlas = AtlasParser.new()
	atlas.loadFromFile(metaPath, format)
	return atlas

func _loadAtlasTex(metaPath, atlas):
	var path = str(_getParentDir(metaPath), "/", atlas.imagePath)
	var tex = null
	if ResourceLoader.has(path):
		tex = ResourceLoader.load(path)
	else:
		tex = ImageTexture.new()
	tex.load(path)
	return tex

func _updatePreview(path):
	var atlas = _loadAtlas(path, get_node("Dialog/Input/Type/TypeButton").get_selected_ID())
	var tex = _loadAtlasTex(path, atlas)
	for i in range(atlas.sprites.size()):
		var item = FrameItem.instance()
		listbox.add_child(item)
		item.texture = tex
		item.frame_meta = atlas.sprites[i]
		item.set_custom_minimum_size(Vector2(0, 80))
	return atlas.sprites.size() > 0

func import(path, meta):
	var srcfile = meta.get_source_path(0)
	var atlas = _loadAtlas(srcfile, meta.get_option("format"))
	var tex = _loadAtlasTex(srcfile, atlas)
	meta.set_source_md5(0, File.new().get_md5(srcfile))
	tex.set_import_metadata(meta)
	if not ResourceLoader.has(path):
		tex.set_path(path)
	else:
		tex.take_over_path(path)
	tex.set_name(path)
	var compression = meta.get_option("compressIndex")
	tex.set_storage(compression)
	if compression == ImageTexture.STORAGE_COMPRESS_LOSSY:
		tex.set_lossy_storage_quality(meta.get_option("compressQuality"))
	ResourceSaver.save(path, tex)
	
	var tarDir = _getParentDir(path)
	
	# Remove exsits atexs
	var dir = Directory.new()
	if dir.open(tarDir) == OK:
		dir.list_dir_begin()
		var f = dir.get_next()
		while f.length():
			print(f)
			if f.begins_with(str(_getFileName(path), ".")) and f.ends_with(".atex") and dir.file_exists(f):
				dir.remove(f)
				print("remove: ",f)
			f = dir.get_next()
	
	for s in atlas.sprites:
		var atex = AtlasTexture.new()
		var ap = str(tarDir, "/", _getFileName(path), ".", _getFileName(s.name),".atex")
		if not ResourceLoader.has(ap):
			atex.set_path(ap)
		else:
			atex.take_over_path(ap)
		atex.set_path(ap)
		atex.set_name(_getFileName(s.name))
		atex.set_atlas(tex)
		atex.set_region(s.region)
		ResourceSaver.save(ap, atex)

func _confirmed():
	var err = dialog.get_node("Status").get_text()
	if err == "":
		var inpath = dialog.get_node("Input/Source/MetaFileField").get_text()
		var outpath = dialog.get_node("Input/Target/TargetDirField").get_text()
		var meta = ResourceImportMetadata.new()
		meta.set_editor("com.geequlim.gdplugin.atlas.importer")
		meta.add_source(inpath)
		meta.set_option("format", dialog.get_node("Input/Type/TypeButton").get_selected_ID())
		meta.set_option("selectIndex", dialog.get_node("Input/Type/TypeButton").get_selected())
		meta.set_option("compressIndex", dialog.get_node("Input/Compress/TypeButton").get_selected())
		meta.set_option("compressQuality", float(dialog.get_node("Input/Compress/Quality/Value").get_text()))
		emit_signal("confim_import", outpath, meta)
		dialog.hide()
	else:
		dialog.get_node("Alter").set_text(err)
		dialog.get_node("Alter").popup()

func showDialog(from):
	var meta = null
	if from and from.length()>0:
		dialog.get_node("Input/Target/TargetDirField").set_text(from)
		meta = ResourceLoader.load_import_metadata(from)
	if meta:
		dialog.get_node("Input/Source/MetaFileField").set_text(meta.get_source_path(0))
		dialog.get_node("Input/Type/TypeButton").select(meta.get_option("selectIndex"))
		dialog.get_node("Input/Compress/TypeButton").select(meta.get_option("compressIndex"))
		dialog.get_node("Input/Compress/Quality/Value").set_text(str(meta.get_option("compressQuality")))
	else:
		dialog.get_node("Input/Source/MetaFileField").set_text("")
		dialog.get_node("Input/Target/TargetDirField").set_text("")
		dialog.get_node("Input/Type/TypeButton").select(0)
		dialog.get_node("Input/Compress/TypeButton").select(0)
		dialog.get_node("Input/Compress/Quality/Value").set_text("1.0")
	_checkPath("")
	dialog.popup()