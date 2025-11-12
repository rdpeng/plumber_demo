#* Say Hello to Someone (query)
#*
#* @get /hello2
#*
#* @query name:string a string indicating the first name
#*
#* @serializer json
#*
function(query) {
    message("incoming API call (query)!")
    paste0("Hello there, ", query$name, "!")
}


