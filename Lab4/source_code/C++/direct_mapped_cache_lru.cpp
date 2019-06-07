#include <iostream>
#include <stdio.h>
#include <math.h>
#include <algorithm>

using namespace std;

struct cache_content
{
	bool v;
	int *tag;
    // unsigned int	data[16];
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


void simulate(int way, int cache_size, int block_size)
{
	int tag, index, x;
	double miss=0, count=0;
	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size / way);
	int line = (cache_size >> (offset_bit));

	int tagbit = 32 - (offset_bit + index_bit);
	cout<<"\033[1;35mneed "<<line * (block_size * 8 + 32 - (int)log2(line) + (int)log2(way) - offset_bit + 1)<<"bits\n\033[0m";

	line /= way;

	cache_content *cache = new cache_content[line];
	
  cout << "cache line: " << line << endl;

	for(int j = 0; j < line; j++){
		cache[j].v = false;
		cache[j].tag = new int[way];
		for(int k=0; k<way; k++)cache[j].tag[k] = -1;
	}
	
    FILE *fp = fopen("RADIX.txt", "r");  // read file
	
	while(fscanf(fp, "%x", &x) != EOF){
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
		count++;
		cache[index].v = true;
		bool check = false;
		for(int i=0; i<way; i++){
			if(tag == cache[index].tag[i]){
				check = true;
				for(int j=i; j>0; j--)swap(cache[index].tag[j], cache[index].tag[j-1]);
				break;
			}
		}
		if(!check){
			miss++;
			cache[index].tag[way-1] = tag;
			for(int i=way-1; i>0; i--)swap(cache[index].tag[i], cache[index].tag[i-1]);
		}
	}
	cout<<"miss rate: "<<miss/count<<endl<<endl;
	fclose(fp);

	delete [] cache;
}
	
int main()
{
	// Let us simulate 4KB cache with 16B blocks
	for(int i=0; i<4; i++){
		for(int j=0; j<6; j++){
			cout<<"\033[1;33m"<<pow(2, i)<<"-way "<<pow(2, j)<<"KB cache with "<<64<<" B blocks"<<"\n";
			simulate(pow(2, i), pow(2, j) * K, 64);
		}
	}
}
