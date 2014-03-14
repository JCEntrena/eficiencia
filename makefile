# Minimal makefile. 
# Written by Haatschii in StackOverflow:
#  http://stackoverflow.com/questions/9787160/makefile-that-compiles-all-cpp-files-in-a-directory-into-separate-executable

CMPLINE=g++ $< -o $@ -std=c++0x -Wall

all: $(patsubst src/%.cpp, %.out, $(wildcard src/*.cpp))

# genera ejecutables en el directorio actual (bin/% no me funciona...)
%: src/%.cpp
	$(CMPLINE)

# make plot generará todas las imágenes a partir de los archivos .dat
plot: all gengraf.sh $(patsubst src/%.cpp, %.jpg, $(wildcard src/*.cpp))

# make data recalcula el archivo .dat de todos los programas
data: all gengraf.sh $(patsubst src/%.cpp, %.dat, $(wildcard src/*.cpp))

fit: all gengraf.sh $(patsubst src/%.cpp, %_fit.jpg, $(wildcard src/*.cpp))

%.jpg: % %.dat
	./gengraf.sh $< 0

%.dat: %
	./gengraf.sh $< 1

%_fit.jpg: bin/%
	./gengraf.sh $< 2



