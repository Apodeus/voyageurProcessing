//This code is based on Daniel Shiffman's Videos
//Just a try for myself
//Actual Complexity is about (n!)

int total = 8; //Nombre total de ville
int radius = 10; //Taille des villes lors de l'affichage en pxl

boolean displayActualPath = true; //permet d'afficher ou non le chemin actuellement testé

int[] ordre; //Tableau des indices mis en parallele avec celui des villes afin.
PVector[] cities; //Tableau de vecteur représentant chaque ville

PVector[] bestPath; //Tableau conservant l'ordre du meilleur chemin
float bestLength = 0; //Taille du meilleur chemin en pxl

int nbPossibilities = facto(total); //Nombre de possibilité à parcourir
float actualSearch = 1; //Actuel avancement dans l'arbre des possibilités

// --------------------------------------- BEGIN SETUP ---------------------------------------------------

//Initialisation des variables
void setup() {
  size(800, 600);
  ordre = new int[total];
  //Génération des villes
  cities = new PVector[total];
  for (int i = 0; i < total; i ++) {
    PVector v = new PVector(random(width), random(height));
    cities[i] = v;
  }

  //Remplissage du tableau des ordres
  for (int i = 0; i < ordre.length; i++)
    ordre[i] = i;

  //Création du premier chemin
  bestPath = cities.clone();
  bestLength= calcDistance(cities);
}

// -------------------------------------------- BEGIN DRAW --------------------------------------------------

void draw() {
  frameRate(2000);
  background(0);
  textSize(32);
  String actPercentage = str((actualSearch * 100) / nbPossibilities) + " %";

  //dessin des villes et du pourcentage de l'avancé actuelle
  fill(255);
  text(actPercentage, 10, 40);
  for (int i = 0; i < total; i ++) {
    ellipse(cities[i].x, cities[i].y, radius * 2, radius * 2);
  }

  //Dessin des lignes reliants les villes
  if (displayActualPath) {
    noFill();
    stroke(255);
    strokeWeight(1);

    beginShape();
    for (int i = 0; i < total; i ++)
      vertex(cities[i].x, cities[i].y);

    endShape();
  }

  //On recalcule la distance du nouveau chemin et on le compare avec le meilleur résultat
  float newDist = calcDistance(cities);
  if (newDist < bestLength) {
    bestLength = newDist;
    bestPath = cities.clone();
    println(bestLength);
  }

  //Dessin en rouge du meilleur chemin
  noFill();
  stroke(255, 60, 0);
  strokeWeight(3);

  beginShape();
  for (int ind = 0; ind < total; ind ++)
    vertex(bestPath[ind].x, bestPath[ind].y);

  endShape();
  
  sort();
}

// ------------------------------ END DRAW -----------------------------------------------------------

void sort() {
  //On finit par passer a la prochaine possibilité.
  int largestI = -1;
  int largestJ = -1;
  //Tri lexicographique - Brute Force
  //Trouve i telque arr[i] < arr[i+1]
  for (int i = 0; i < ordre.length - 1; i++)
    if (ordre[i] < ordre[i+1])
      largestI = i;

  if (largestI == -1) {
    println("Finished");
    noLoop();
  }
  //trouve j telque arr[i] < arr[j]
  for (int j = 0; j < ordre.length; j++)
    if (largestI != -1 && ordre[largestI] < ordre[j])
      largestJ = j;

  //Verification de la validité des index
  if (largestI < 0 || largestJ < 0) {
    noLoop();
  } else { // On passe à la possibilité suivante
    actualSearch ++;
    swap(ordre, largestI, largestJ);
    reverseIndex(ordre, largestI + 1, ordre.length -1);
  }
}

// ---------------------------- Some Functions (swap/reverse/distance/Factoriel..) ------------------

//Calcule et retourne la distance du chemin mis en parametre
float calcDistance(PVector[] path) {
  float sum = 0;
  for (int i = 0; i < path.length - 1; i++) {
    sum += dist(path[i].x, path[i].y, path[i+1].x, path[i+1].y);
  }

  return sum;
}

//Echange de position de deux entier dans l'ordre arr, et dans le tableau cities en meme temps
void swap(int[] arr, int i, int j) {
  int tmp = arr[i];
  arr[i] = arr[j];
  arr[j] = tmp;

  PVector tmp_citie = cities[i].copy();
  cities[i] = cities[j];
  cities[j] = tmp_citie;
}

//Renverse un tableau depuis l'index i jusqu'a l'index n. Est appliqué aussi au tableau des villes
void reverseIndex(int[] arr, int i, int n) {
  while (i < n) {
    swap(arr, i, n); // on inverse l'ordre des index, et les villes en meme temps
    i++;
    n--;
  }
}

//Calcul et retourne (nombre!) de facon iterative
int facto(int nombre) {
  int fact = 1;
  for (int i = 2; i <= nombre; i++)
    fact *= i;

  return fact;
}