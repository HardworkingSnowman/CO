CC=g++

SRC=$(wildcard ./*.cpp)
OUT=$(wildcard ./*.o)
OBJ=$(patsubst ./%.cpp, ./%.o, $(SRC))

all:
	$(CC) direct_mapped_cache.cpp -o direct_mapped_cache.o
	$(CC) direct_mapped_cache_lru.cpp -o direct_mapped_cache_lru.o

.PHONY:
	clean

clean:
	rm $(OUT)
