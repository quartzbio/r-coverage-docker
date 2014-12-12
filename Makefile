NAME=rcov-r302

build: 
	docker build -t $(NAME) .

run:
	docker run -ti  $(NAME)

run-bash: 
	docker run -ti  $(NAME) bash

run-test: 
	docker run -ti $(NAME) Rscript test.R


