# Eficiencia de algoritmos.
# makefile.
# Basado en: http://stackoverflow.com/questions/9787160/makefile-that-compiles-all-cpp-files-in-a-directory-into-separate-executable

BIN=./bin
SRC=./src
DATA=./data
PLOT=./plots
FIT=./regressionPlots
TEX=./tex
FLAGS=-std=c++0x -Wall

# make all: Compilar todos los programas 
all: $(patsubst $(SRC)/%.cpp, $(BIN)/%, $(wildcard $(SRC)/*.cpp))

# make data: Recalcular el archivo .dat de todos los programas
data: all gengraf.sh $(patsubst $(SRC)/%.cpp, $(DATA)/%.dat, $(wildcard $(SRC)/*.cpp))

# make plot: Generar todas las imágenes a partir de los archivos .dat
plot: gengraf.sh $(patsubst $(SRC)/%.cpp, $(PLOT)/%.jpg, $(wildcard $(SRC)/*.cpp))

# make fit: Crear las imágenes con las funciones de ajuste
fit: gengraf.sh $(patsubst $(SRC)/%.cpp, $(FIT)/%.fit, $(wildcard $(SRC)/*.cpp))

# make codetex: Crear los archivos LaTeX de código resaltado
codetex: $(patsubst $(SRC)/%.cpp, $(TEX)/%.tex, $(wildcard $(SRC)/*.cpp))

# Opciones individuales 
$(BIN)/%: $(SRC)/%.cpp
	g++ $< -o $@ $(FLAGS)

$(DATA)/%.dat: $(BIN)/%
	./gengraf.sh $< 0 > $@

$(PLOT)/%.jpg: $(DATA)/%.dat
	./gengraf.sh $< 1

$(FIT)/%.fit: $(DATA)/%.dat
	./gengraf.sh $< 2 > $@

#$(FIT)/%.fit.jpg: $(DATA)/%.dat
#	./gengraf.sh $< 2

$(TEX)/%.tex: $(SRC)/%.cpp
	source-highlight -f latexcolor -i $< -o $@
$(TEX)/makefile.tex: makefile
	source-highlight -f latexcolor -i $< -o $@

# Limpieza de los ejecutables
clean:
	rm $(BIN)/*

cleanall: clean
	rm *.jpg *.dat tex/*
