#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content
{
	bool v;
	unsigned int tag;
    // unsigned int	data[16];
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


void simulate(int cache_size, int block_size)
{
	unsigned int tag, index, x;
	double count=0, miss=0;
	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);

	cache_content *cache = new cache_content[line];
	
    cout << "cache line: " << line << endl;

	for(int j = 0; j < line; j++)
		cache[j].v = false;
	
    FILE *fp = fopen("ICACHE.txt", "r");  // read file
	
	while(fscanf(fp, "%x", &x) != EOF)
    {
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
		count++;
		if(cache[index].v && cache[index].tag == tag)
			cache[index].v = true;    // hit
		else
        {
			cache[index].v = true;  // miss
			cache[index].tag = tag;
			miss++;
		}
	}
	cout<<"miss rate : "<<miss/count<<endl<<endl;
	fclose(fp);

	delete [] cache;
}
	
int main()
{
	// Let us simulate pow(4, i) KB cache with 16 * pow(2, j) B blocks
	for(int i=1; i<5; i++){
		for(int j=0; j<4; j++){
			cout<<"\033[1;33m"<<pow(2, i)*16<<"B cache with "<<4*pow(2, j)<<"B blocks\n\033[0m";
			simulate(pow(2, i)*16, 4*pow(2, j));
		}
	}
	//for(int j=0; j<5; j++)simulate(16*K, 16 * pow(2, j));
}
