r-coverage-docker
=================

A docker container providing:
  * a patched R interpreter/installation with builtin coverage support.
  * and also a normal (unpatched) R for easy comparison. 
  
 Both R installations share installed packages.

## Getting Started
After the build:

 * code coverage of the included testthat package: `make run-test`
 * run the patched interpreter interactive console: `make run`

And don't forget to Star the project if you like it!

## Contents

* [Introduction](#introduction)

* [Installation](#installation)
	* [Building the docker container](#building-the-docker-container)

* [Usage](#usage)

## Introduction

This project allows to build a docker container containing a patched version of the R interpreter
which provides a new feature: **code coverage**.

## Installation

It should work on all platforms supporting docker: cf https://docs.docker.com/installation/.
The very first step is to install docker.

### Building the docker container

#### prerequisites
A unix-like terminal and GNU make.

#### clone the r-coverage github project: 

```bash
git clone https://github.com/quartzbio/r-coverage.git
cd r-coverage
# build the docker container: QUITE LONG
make build
```

## Usage

The docker container contains two R versions:
 * the normal one (unpatched), available as R and Rscript in the docker container
 * the patched one, available, available as Rcov and Rscript_cov in the docker container
 * 
All installed packages (present and future) are shared between the two R installations for convenience.

The essential **devtools** package is preinstalled.



### running the provided example: testthat code coverage

```
make run-test
```
This runs the testthat (version 0.7.1) own test suite, and displays in a crude way the corresponding code coverage.
Excerpt of the output:
```
$`/home/docker/testthat/R/utils.r`
     [,1] [,2]
[1,]    2    1
[2,]    3   55
[3,]    4   55
```
It means that the line 2 has been hit 1 time, thes line 3 and 4 55 times. 

### running an interactive console session
Type `make run`, you end up in the patched R console.
**Rcov_start()** starts the code coverage tracking, then execute your code, and finally  Rcov_stop() stops the 
tracking and returns an environment, with the tracked source file names as keys and hit matrices as values.

All the tracked code must have source reference attached. This is normally done by sourc()ing files, or loading packages. To simulate it in an interactive session, we can use the arse(text = , keep.source = TRUE) function.

Example of a session:
```r
### code to define a function
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

### parse it with source references, and evaluate it.
expr <- parse(text = code, keep.source = TRUE)
eval(expr)

### execute a function call, tracking the code coverage
Rcov_start()
tested_function(1)

res <- as.list(Rcov_stop())
print(res)
```

### coverage of a CRAN package
Let's look at the coverage of the stringr package:
Launch the R patched console: `make run`
```r
library(devtools)
pkg <- download.packages('stringr', '.')
untar(pkg[2], compressed=TRUE)
Rcov_start()
test('stringr')
res <- as.list(Rcov_stop())
print(res)
```

### coverage of a github package
Let's look at the coverage of the crayon package:
Launch the R patched console: `make run`
```r
library(devtools)

# the R-3.0.2 is quite old now, get a compatible version
pkg <- devtools:::github_remote("hadley/stringr", ref = 'stringr-0.6.2')
fname <- devtools:::remote_download(pkg)
repo <- dirname(files[1])
files <- unzip(fname)
repo <- dirname(files[1])
Rcov_start()
test(repo)
res <- as.list(Rcov_stop())
print(res)
```

### coverage of a local source package (or script)
We can use the docker volume feature (shared filesystem) to mount a local directory inside the docker container.
Suppose that the R source code is in the $DIR directory on the local filesystem.
We will mount the directory $DIR as ~/code in the docker:
```bash
docker run -ti  -v $DIR:/home/docker/code rcov-r302
>setwd('code')
...
```











