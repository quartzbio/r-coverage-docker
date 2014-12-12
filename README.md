r-coverage
==========

A docker container providing:
  * a patched R interpreter/installation with builtin coverage support.
  * and also a normal (unpatched) for easy comparison. 
  
 Both R installations share installed packages.

## Getting Started
After the build:

 * code coverage of the included testthat package: `make run-test`
 * run the patched interpreter interactive console: `make run`

And don't forget to Star the project if you like it!

## Contents

* [Introduction](#Introduction)

* [Installation](#Installation)
	* [Building the docker container](#uilding the docker container)

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











