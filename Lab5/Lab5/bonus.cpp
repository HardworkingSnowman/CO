#include <iostream>
#include <stdio.h>
#include <math.h>
#include <algorithm>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>

using namespace std;

unsigned int A_base, B_base, C_base;
int m, n, p;
vector<unsigned int> addr;

struct cache_content
{
	bool v;
	int *tag;
    // unsigned int	data[16];
};

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


int simulate(int way, int cache_size, int block_size, int type)
{
	int tag, index, x;
	double miss=0, count=0;
	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size / way);
	int line = (cache_size >> (offset_bit));
	int tagbit = 32 - (offset_bit + index_bit);
	line /= way;
	cache_content *cache = new cache_content[line];
	for(int j = 0; j < line; j++){
		cache[j].v = false;
		cache[j].tag = new int[way];
		for(int k=0; k<way; k++)cache[j].tag[k] = -1;
	}
	for(vector<unsigned int>::iterator it=addr.begin(); it!=addr.end(); it++){
		x = *it;
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
	delete [] cache;
	if(type == 0){ // one-word-wide
		return 836 * miss + 4 * (count - miss);
	}
	else if(type == 1){	// wider memory
		return 108 * miss + 4 * (count - miss);
	}
	else if(type == 2){ // L1
		return 55 * miss + 3 * (count - miss);
	}
	else{	// L2
		return (3639-55) * miss;
	}
}

void aaa(ofstream &out){
	out << "sss\n";
}

int execution_cycles() {
    return 2 + (22 * m * p * n + 2 * m * p) + (5 * m * p + 2 * m) + (5 * m + 2) + 1;
}
	
int main(int argc, char *argv[]){
	// 處理輸入 argv[1] 檔案
	FILE *fin = fopen(argv[1], "r");

	fscanf(fin, "%x%x%x", &A_base, &B_base, &C_base);
	fscanf(fin, "%d%d%d", &m, &n, &p);
	int A[m][n], B[n][p], C[m][p];
	for(int i=0; i<m; i++){
		for(int j=0; j<n; j++){
			fscanf(fin, "%d", &A[i][j]);
		}
		for(int j=0; j<p; j++){
			C[i][j]=0;
		}
	}
	for(int i=0; i<n; i++){
		for(int j=0; j<p; j++){
			fscanf(fin, "%d", &B[i][j]);
		}
	}
	// 矩陣相乘, 會需要用到的位址
	for(int i=0; i<m; i++){
		for(int j=0; j<p; j++){
      addr.push_back(4 * (i * p + j) + C_base);
			for(int k=0; k<n; k++){
				addr.push_back(4 * (i * n + k) + A_base);
				addr.push_back(4 * (k * p + j) + B_base);
				addr.push_back(4 * (i * p + j) + C_base);
				C[i][j] += A[i][k] * B[k][j];
			}
		}
	}
	// 將矩陣結果印到 argv[2] 檔案中
	ofstream out(argv[2]);
	for(int i=0; i<m; i++){
		ostringstream oss;
		for(int j=0; j<p; j++){
			oss << C[i][j] << " ";
		}
		oss << "\n";
		out << oss.str();
	}
	// 分析 cycle
	ostringstream oss;
	// 	execution cycle
	oss << execution_cycles() << " ";
	//  One-word-wide memory organization
	oss << simulate(8, pow(2, 9), pow(2, 5), 0) << " ";
	//  Wider memory organization
	oss << simulate(8, pow(2, 9), pow(2, 5), 1) << " ";
	//  Two-level memory organization
	oss << simulate(8, pow(2, 7), pow(2, 4), 2) + simulate(8, pow(2, 12), pow(2, 7), 3) << " ";

	oss << "\n";
	out << oss.str();
	out.close();
}
