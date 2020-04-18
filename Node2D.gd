extends Node2D

var player_words=[]
var current_story
var prompt_counter=0

func _ready():
	set_random_story()
	#$BlackBoard/ProgressCounter.max_value=current_story.plugin_words.size()+1
	#print(prompt_counter)
	$BlackBoard/TextBox.clear()
	$BlackBoard/AgainButton.hide()
	$BlackBoard/AgainButton/AgainLabel.hide()
	var welcome="Welcome to my Loony Lips game!\nHere we are going to create funny stories, and have a great time!\nReady?\n\nCan I have " + current_story.plugin_words[player_words.size()] + ", please?"
	$BlackBoard/StoryText.text=(welcome)
	
func set_random_story():
	var stories=get_fron_jason("Stories.json")
#	print("stories=",stories)
	randomize()
	current_story=stories[ randi() % stories.size()]
	
func get_fron_jason(filename):
	var file=File.new()# the file object
	file.open(filename,File.READ)#assumes the file exists
	var text= str(file.get_as_text())
	print("text type is: ",text)
	var data=parse_json(text)
	print ("data= ",data)
	file.close()
	return data

func _on_OkButton_pressed():
	var new_text=$BlackBoard/TextBox.get_text()
	_on_TextBox_text_entered(new_text)


func _on_TextBox_text_entered(new_text):
	player_words.append(new_text)
	$BlackBoard/TextBox.clear()
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
	$BlackBoard/StoryText.text= "Can I have " + current_story.plugin_words[player_words.size()] + ", please?"
#	print("plugin words size=",current_story.plugin_words.size())
	_on_ProgressCounter_ready(current_story.plugin_words.size())
	

#reset the game:
func _on_AgainButton_pressed():
	get_tree().reload_current_scene()



func _on_ProgressCounter_ready(plugin_words_length):
	var precent_counter= 100/ (plugin_words_length)
	prompt_counter= prompt_counter+precent_counter
	$BlackBoard/ProgressCounter.value=prompt_counter
