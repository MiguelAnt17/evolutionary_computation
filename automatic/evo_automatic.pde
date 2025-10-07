import java.util.*; 

PImage target;
int cols, rows;
float cellSize;
int painelLargura = 250; 

int evalSize = 100;
PGraphics buffer;

void setup() {
  fullScreen();

  target = loadImage("individuo_12.png");
  target.resize(evalSize, evalSize);
  target.filter(GRAY);

  buffer = createGraphics(evalSize, evalSize);

  initPopulacao();

  cols = ceil(sqrt(tamanhoPop));
  rows = ceil(float(tamanhoPop) / cols);
  cellSize = (width - painelLargura) / float(cols);
}

void draw() {
  background(255);

  avaliarPopulacao();

  Collections.sort(populacao, new Comparator<Individuo>() {
    public int compare(Individuo a, Individuo b) {
      return Float.compare(b.fitness, a.fitness);
    }
  });

  int k = 0;
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      if (k < populacao.size()) {
        Individuo ind = populacao.get(k);

        stroke(200);
        noFill();
        rect(c * cellSize, r * cellSize, cellSize, cellSize);

        ind.display(c * cellSize, r * cellSize, cellSize);

        fill(0);
        textAlign(CENTER, TOP);
        text("F=" + int(ind.fitness) + "%", c * cellSize + cellSize/2, r * cellSize + 5);
      }
      k++;
    }
  }

  fill(240);
  noStroke();
  rect(width - painelLargura, 0, painelLargura, height);

  fill(0);
  textAlign(CENTER, TOP);
  textSize(16);
  text("Target", width - painelLargura/2, 20);

  imageMode(CENTER);
  image(target, width - painelLargura/2, height/2);

  // info da geração
  fill(0);
  textAlign(LEFT, BOTTOM);
  textSize(14);
  text("Geração: " + geracao, 20, height - 20);

  // evolução automática
  if (frameCount % 30 == 0) {
    novaGeracao();
  }
}
