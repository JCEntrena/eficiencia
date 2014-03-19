# Eficiencia de algoritmos.
# makefile.
# Basado en: http://stackoverflow.com/questions/9787160/makefile-that-compiles-all-cpp-files-in-a-directory-into-separate-executable

CMPLINE=g++ $< -o $@ -std=c++0x -Wall

# make all: Compilar todos los programas 
all: $(patsubst src/%.cpp, bin/%, $(wildcard src/*.cpp))

# make data: Recalcular el archivo .dat de todos los programas
data: all gengraf.sh $(patsubst src/%.cpp, %.dat, $(wildcard src/*.cpp))

# make plot: Generar todas las imágenes a partir de los archivos .dat
plot: gengraf.sh $(patsubst src/%.cpp, %.jpg, $(wildcard src/*.cpp))

# make fit: Crear las imágenes con las funciones de ajuste
fit: gengraf.sh $(patsubst src/%.cpp, %_fit.jpg, $(wildcard src/*.cpp))

# make codetex: Crear los archivos LaTeX de código resaltado
codetex: $(patsubst src/%.cpp, tex/%.tex, $(wildcard src/*.cpp))

# Opciones individuales 
bin/%: src/%.cpp
	$(CMPLINE)

%.jpg: bin/% %.dat
	./gengraf.sh $< 0

%.dat: bin/%
	./gengraf.sh $< 1

%_fit.jpg: bin/% %.dat
	./gengraf.sh $< 2

tex/%.tex: src/%.cpp
	source-highlight -f latexcolor -i $< -o $@

# Limpieza de los ejecutables
clean:
	rm bin/*

cleanall: clean
	rm *.jpg *.dat tex/*