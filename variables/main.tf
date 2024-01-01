resource "local_file" "foo"{
	content = var.content
	filename = "/Users/daisydharshini/Documents/sam_tf.txt"
}
variable "content"{
	type = string
	description = "content of the file to be created"
	validation {
	   condition = substr(var.content,0,4) == "foo-"
	   error_message = "The content of the var must be valid starting with \"foo-\"."
        }
	
}


