r-coverage
==========

Docker container providing a patched R interpreter with builtin coverage support.

## Getting Started


## Contents

* [Introduction](#intro)

* [Installation](#install)

	* [Building the docker container](#build)

## Introduction (#intro)

This project allows to build a docker container containing a patched version of the R interpreter
which provides a new feature: **code coverage**.

## Installation (#install)

It should work on all platforms supporting docker: cf https://docs.docker.com/installation/
The very first step is to install docker.

### Building the docker container (#build)

#### prerequisites
A unix-like terminal and GNU make.

#### clone the r-coverage github project: 

```
git clone https://github.com/quartzbio/r-coverage.git
cd r-coverage
# build the docker container: QUITE LONG
make build
```











