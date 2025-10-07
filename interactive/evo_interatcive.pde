int cols, rows;
float cellSize;

void setup() {
  fullScreen();
  initPopulacao();

  cols = ceil(sqrt(tamanhoPop));
  rows = ceil(float(tamanhoPop) / cols);
  cellSize = width / float(cols);
}

void draw() {
  background(255);
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
        text("F=" + nf(ind.fitness, 1, 1), c*cellSize + cellSize/2, r*cellSize+5);
      }
      k++;
    }
  }
  fill(0);
  text("Geração: " + geracao, 100, height-30);
}

void keyPressed() {
  int nota = -1;
  if (key >= '1' && key <= '9') nota = key - '0';
  if (key == '0') nota = 10;

  if (nota != -1) {
    int c = int(mouseX / cellSize);
    int r = int(mouseY / cellSize);
    int idx = r * cols + c;
    if (idx >= 0 && idx < populacao.size()) {
      populacao.get(idx).fitness = nota;
    }
  }

  if (key == 'n' || key == 'N' || keyCode == ENTER) {
    novaGeracao();
  }
}

// guardar indivíduo em PNG ao carregar S
void keyReleased() {
  if (key == 's' || key == 'S') {
    int c = int(mouseX / cellSize);
    int r = int(mouseY / cellSize);
    int idx = r * cols + c;
    if (idx >= 0 && idx < populacao.size()) {
      salvarIndividuo(populacao.get(idx), idx);
    }
  }
}

void salvarIndividuo(Individuo ind, int idx) {
  int imgSize = 400;
  PGraphics pg = createGraphics(imgSize, imgSize);
  pg.beginDraw();
  pg.background(255);
  ind.render(pg, imgSize); // usa função centrada
  pg.endDraw();
  String nomeFicheiro = "individuo_" + idx + ".png";
  pg.save(nomeFicheiro);
  println("Indivíduo " + idx + " guardado em " + nomeFicheiro);
}
