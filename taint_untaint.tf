// If any manual exec happened, resource needs to be destroyed and recreated. To avoid that we are marking the resource as Tainted so tf taking the resource to be recreated 

resource "loca_file" "pets"{
    filename = "/root/pets.txt"
    content = "pets are awesome and dogs blocks contains ${data.loca_file.dogs}"
    provisioner "local-exec"{
        command = "echo ${aws_instance.webserver-3,public_ip}" > /temp/pub_ip.txt
    }
}

terraform taint aws_instance.webserver-3

To untaint the resource :

terraform untaint aws_instance.webserver-3

