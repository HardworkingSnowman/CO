CC=g++

SRC=$(wildcard ./*.cpp)
OUT=$(wildcard ./*.o)
OBJ=$(patsubst ./%.cpp, ./%.o, $(SRC))

all:
	$(CC) direct_mapped_cache_lru.cpp -o ./simulate_caches
	$(CC) bonus.cpp -o ./bonus

.PHONY:
	clean

clean:
	rm $(OUT)
