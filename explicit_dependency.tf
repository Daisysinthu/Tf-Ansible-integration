resource "local_file" "pet"{
        content = "My favorite pet is ${random_pet.my_pet.id}"
        filename = "/Users/daisydharshini/Documents/sam_tf.txt"
        depends_on = [
           random_pet.my_pet
        ]
}

resource "random_pet" "my_pet"{
}
