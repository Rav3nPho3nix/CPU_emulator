target: build

build:
	gprbuild -gnatyy

run:
	./bin/cpu.out

clean:
	gprclean
	rm -rd ./bin ./obj