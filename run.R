## Run server

library(plumber)

pr("test2.R") |>
    pr_run(host = "164.90.154.116",
           port = 8000)