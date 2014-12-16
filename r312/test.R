library(methods)
library(devtools)

Rcov_start()
test('testthat')
env <- Rcov_stop()

res <- lapply(ls(env), get, envir = env)
names(res) <- ls(env)
print(res)
