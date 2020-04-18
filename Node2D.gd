extends Node2D

var player_words=[]
var current_story
var strings
var prompt_counter=0

func _ready():
	set_random_story()
	$BlackBoard/TextBox.clear()
	$BlackBoard/AgainButton.hide()
	$BlackBoard/AgainButton/AgainLabel.hide()
	strings= get_fron_jason("Strings.json")
	var welcome= strings["welcome"]
	$BlackBoard/StoryText.text=(welcome)
	prompt_player()
	#var welcome="Welcome to my Loony Lips game!\nHere we are going to create funny stories, and have a great time!\nReady?\n\nCan I have " + current_story.plugin_words[player_words.size()] + ", please?"
	
	
func set_random_story():
	var stories=get_fron_jason("Stories.json")
	randomize()
	current_story=stories[ randi() % stories.size()]
	
	
func get_fron_jason(filename):
	var file=File.new()# the file object
	file.open(filename,File.READ)#assumes the file exists
	var text= str(file.get_as_text())
	var data=parse_json(text)
	file.close()
	return data


func _on_OkButton_pressed():
	var new_text=$BlackBoard/TextBox.get_text()
	handle_text(new_text)


func _on_TextBox_text_entered(new_text):
	handle_text(new_text)


func handle_text(myText):
	player_words.append(myText)
	$BlackBoard/TextBox.clear()
	$BlackBoard/StoryText.clear()
	check_player_words_length()


func check_player_words_length():
	if player_words.size()==current_story.plugin_words.size():
		show_story()
	else:
		prompt_player()



func show_story():
	$BlackBoard/TextBox.hide()
	$BlackBoard/OkButton.hide()
	$BlackBoard/OkButton/OkLable.hide()
	$BlackBoard/AgainButton.show()
	$BlackBoard/AgainButton/AgainLabel.show()
	$BlackBoard/ProgressCounter.hide()
	$BlackBoard/ProgressCounter/ProgressLabel.hide()
	$BlackBoard/StoryText.text= current_story.story % player_words


func prompt_player():
	var next_plugin_word = current_story["plugin_words"][player_words.size()]
#	$BlackBoard/StoryText.text= "Can I have " + current_story.plugin_words[player_words.size()] + ", please?"
	$BlackBoard/StoryText.text +=(strings["prompt"] % next_plugin_word)
	change_progress_bar()
	
	
func change_progress_bar():
	$BlackBoard/ProgressCounter.value=prompt_counter
	var precent_counter= 100/ (current_story.plugin_words.size())
	prompt_counter= prompt_counter+precent_counter


#reset the game:
func _on_AgainButton_pressed():
	get_tree().reload_current_scene()
