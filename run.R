## Run server

library(plumber2)

pa <- api("test2.R",
          host = "164.90.154.116",
          port = 8000)
api_run(pa)
