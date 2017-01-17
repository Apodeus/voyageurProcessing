#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

void swap(int* arr, int i, int j){
	int tmp = arr[i];
	arr[i] = arr[j];
	arr[j] = tmp;
}

void reverse(int* arr, int i, int n){
	while(i < n){
		swap(arr, i, n);
		i++;
		n--;
	}
}

float dist(float x1, float y1, float x2, float y2){
	return(sqrt((abs(x1 - x2) * abs(x2 - x2)) + (abs(y1 - y2) * abs(y1 - y2))));
}

float calcDistance(int** path, int* order, int len) {
  float sum = 0;
  for (int i = 0; i < len - 1; i++) {
    sum += dist(path[order[i]][0], path[order[i]][1], path[order[i+1]][0], path[order[i+1]][1]);
  }
  return sum;
}

int sort(int* order, int len){
	int largestI = -1;
	int largestJ = -1;

	for(int i = 0;i < len - 1; i++){
		if(order[i] < order[i + 1])
			largestI = i;
	}

	if(largestI == -1){
		printf("Finished\n");
		return largestI;
	}

	for(int j = 0; j < len; j++){
		if(largestI != -1 && order[largestI] < order[j])
			largestJ = j;
	}

	if(largestI >= 0 && largestJ >= 0){
		swap(order, largestI, largestJ);
		reverse(order, largestI + 1, len - 1);
	}
	return largestI;
}

void copy(int* src, int* dest, int len){
	for(int i = 0; i < len; i++)
		dest[i] = src[i];
}

void dispArray(int* array, int len){
	for(int i = 0; i < len; i++)
		printf("a[%d]: %d\n", i, array[i]);
}

void dispArray2D(int** tab, int len){
	for(int i = 0; i < len; i ++){
		printf("t[%d] = (%d;%d)\n", i, tab[i][0], tab[i][1]);
	}

}

void setup(int* ordre){


}

int **createTable(int nbLin, int nbCol){
	int **tableau = (int **)malloc(sizeof(int*)*nbLin);
	int *tableau2 = (int *)malloc(sizeof(int)*nbCol*nbLin);
	for(int i = 0 ; i < nbLin ; i++){
		tableau[i] = &tableau2[i*nbCol];
	}
	return tableau;
}

void free2DTab(int** tab){
	free(tab[0]);
	free(tab);
}

void generatePoints(int** tab, int len){
	srand(time(NULL));
	for(int i = 0; i < len; i++){
		int x = rand()%600;
		int y = rand()%600;
		tab[i][0] = x;
		tab[i][1] = y;
	}
}

int main(int argc, char* argv[]){
	int total = 10;
	int* ordre = (int*)malloc(sizeof(int)*total);
	int* bestPath = (int*)malloc(sizeof(int)*total);
	int** points = createTable(total, 2);

	for(int i = 0; i < total; i++)
		ordre[i] = i;

	copy(ordre, bestPath, total);
	generatePoints(points, total);

	float bestLength = calcDistance(points, ordre, total);

	while(sort(ordre, total) != -1){
		float newDist = calcDistance(points, ordre, total);
		if (newDist < bestLength) {
			bestLength = newDist;
			copy(ordre, bestPath, total);
		}
	}

	printf("bd : %f\n", bestLength);
	printf("Dernier ordre traité : \n");
	dispArray(ordre, total);
	printf("\nMeilleur ordre trouvé : \n");
	dispArray(bestPath, total);
	printf("\nPoints générés : \n");
	dispArray2D(points, total);

	free(ordre);
	free(bestPath);
	free2DTab(points);
}