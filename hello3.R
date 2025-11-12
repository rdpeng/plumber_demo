#* Say Hello to Someone (POST)
#*
#* @post /hello3
#*
#* @body a string indicating the person's first name
#*
#* @serializer json
#*
function(body) {
    message("incoming API call (POST)!")
    paste0("Hello there, ", body, "!")
}
