# Minimal makefile. 
# Written by Haatschii in StackOverflow:
#  http://stackoverflow.com/questions/9787160/makefile-that-compiles-all-cpp-files-in-a-directory-into-separate-executable

all: $(patsubst %.cpp, %, $(wildcard *.cpp))

%: %.cpp Makefile
    g++ $< -o $@ -std=c++0x --Wall
