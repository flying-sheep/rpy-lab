run: build
	docker run -it -p 8888:8888 -v "$(PWD)":/home/jovyan/work rpy-lab

rpy-lab.tar.gz: build
	docker export $(shell docker create rpy-lab) | pigz --best > $@

build:
	docker build -t rpy-lab .
