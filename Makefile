target: build

build:
	gprbuild

run:
	./bin/cpu.out

clean:
	gprclean
	rm -rd ./bin ./obj