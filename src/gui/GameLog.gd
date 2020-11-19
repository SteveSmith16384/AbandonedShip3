extends CanvasLayer

var log_text = []

func append(text):
	log_text.push_back(text)
	if log_text.size() >= 5:
		log_text.remove(0)
		
	var label = get_node("Label")
	label.text = ""
	for t in log_text:
		label.text = label.text + "\n" + t
