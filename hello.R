#* Say Hello to Someone
#*
#* @get /hello/<name>
#*
#* @param name a string indicating a first name
#*
#* @serializer json
#*
function(name) {
    message("incoming API call!")
    paste0("Hello there, ", name, "!")
}

