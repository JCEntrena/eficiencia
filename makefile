# Minimal makefile. 
# Written by Haatschii in StackOverflow:
#  http://stackoverflow.com/questions/9787160/makefile-that-compiles-all-cpp-files-in-a-directory-into-separate-executable

all: $(patsubst src/%.cpp, bin/%, $(wildcard src/*.cpp))

bin/%: src/%.cpp Makefile
    g++ $< -o $@ -std=c++0x --Wall

plot: all gengraf.sh $(patsubst src/%.cpp, %.jpg, $(wildcard src/*.cpp))

data: all gengraf.sh $(patsubst src/%.cpp, %.dat, $(wildcard src/*.cpp))

%.dat: bin/%
	./gengraf.sh $< 1

%.jpg: bin/%
	./gengraf.sh $<