# Makefile for SnowAlgaeModel v1.0
# Jan.24 2022 Yukihiko Onuma

all: clean dir

dir:
	mkdir ./work
	cp ./source/* ./work

clean:
	@rm -rf ./work 

