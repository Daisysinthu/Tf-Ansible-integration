resource "loca_file" "pets"{
    filename = "/root/pets.txt"
    content = "pets are awesome and dogs blocks contains ${data.loca_file.dogs}"
}

data "loca_file" "dogs"{
    filename = "/root/dogs.txt"
}
