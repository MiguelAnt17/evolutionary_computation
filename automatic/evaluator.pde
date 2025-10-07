class Evaluator {
  PImage target;

  Evaluator(PImage t) {
    target = t;
  }

  float avaliar(Individuo ind) {
    // desenhar indivíduo num buffer
    PGraphics pg = createGraphics(target.width, target.height);
    pg.beginDraw();
    pg.background(255);
    pg.translate(pg.width/2, pg.height/2);
    pg.noFill();
    pg.stroke(0);
    ind.desenhar(pg);
    pg.endDraw();

    pg.loadPixels();
    target.loadPixels();

    float score = 0;
    int activeCount = 0;

    // percorre todos os pixels
    for (int i=0; i<pg.pixels.length; i++) {
      float tb = brightness(target.pixels[i]);
      
      // só compara onde o target tem "informação" (pixels não brancos)
      if (tb < 250) {
        float diff = abs(brightness(pg.pixels[i]) - tb);
        score += diff;
        activeCount++;
      }
    }

    // se não houver pixels ativos no target → fitness = 0
    if (activeCount == 0) return 0;

    // normaliza para intervalo [0..1]
    float fitness = 1.0 - (score / (activeCount * 255.0));
    fitness = constrain(fitness, 0, 1);

    return fitness;
  }
}
