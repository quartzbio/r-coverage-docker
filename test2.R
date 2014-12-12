library(devtools)
library(methods)
"tested_function <- function(x) {  # 1
  if (x == 0) return(0)
	
  y <- 1
  a <- 3 + y
  for (i in 1:10) {
	  a <- a + y + x           # 7
  }
  if (x == 1) return(1)
  
  a <- y + 3
  
  x + a                             # 13
}
" -> code

expr <- parse(text = code, keep.source = TRUE)
eval(expr)

Rcov_start()
tested_function(1)
env <- Rcov_stop()

res <- lapply(ls(env), get, envir = env)
names(res) <- ls(env)
print(res)

