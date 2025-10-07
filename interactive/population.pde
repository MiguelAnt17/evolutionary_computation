ArrayList<Individuo> populacao;
int tamanhoPop = 30;  
int geracao = 0;

class Individuo {
  Superformula[] formas;   
  float fitness = 1;

  Individuo() {
    formas = new Superformula[2];
    for (int i = 0; i < formas.length; i++) {
      formas[i] = new Superformula();
    }
  }

  // desenhar dentro da grelha
  void display(float x, float y, float s) {
    pushMatrix();
    translate(x + s/2, y + s/2);
    stroke(0);
    noFill();

    int pontos = 360;
    float[] valoresR = new float[pontos];
    float maxR = 0;

    for (int j = 0; j < pontos; j++) {
      float ang = map(j, 0, pontos, 0, TWO_PI);
      float r = 0;
      for (int i = 0; i < formas.length; i++) {
        r += formas[i].formula(ang);
      }
      r /= formas.length;
      r = max(r, 0.0001);
      r = min(r, 5.0);
      valoresR[j] = r;
      if (r > maxR) maxR = r;
    }

    beginShape();
    float raioMax = s/2.5;
    for (int j = 0; j < pontos; j++) {
      float ang = map(j, 0, pontos, 0, TWO_PI);
      float rNorm = (maxR > 0) ? sqrt(valoresR[j] / maxR) : 0;
      float px = raioMax * rNorm * cos(ang);
      float py = raioMax * rNorm * sin(ang);
      vertex(px, py);
    }
    endShape(CLOSE);

    popMatrix();
  }

  // desenhar centrado num PGraphics (para exportação)
  void render(PGraphics pg, float s) {
    pg.pushMatrix();
    pg.translate(pg.width/2, pg.height/2);
    pg.stroke(0);
    pg.noFill();

    int pontos = 360;
    float[] valoresR = new float[pontos];
    float maxR = 0;

    for (int j = 0; j < pontos; j++) {
      float ang = map(j, 0, pontos, 0, TWO_PI);
      float r = 0;
      for (int i = 0; i < formas.length; i++) {
        r += formas[i].formula(ang);
      }
      r /= formas.length;
      r = max(r, 0.0001);
      r = min(r, 5.0);
      valoresR[j] = r;
      if (r > maxR) maxR = r;
    }

    pg.beginShape();
    float raioMax = s/2.5;
    for (int j = 0; j < pontos; j++) {
      float ang = map(j, 0, pontos, 0, TWO_PI);
      float rNorm = (maxR > 0) ? sqrt(valoresR[j] / maxR) : 0;
      float px = raioMax * rNorm * cos(ang);
      float py = raioMax * rNorm * sin(ang);
      pg.vertex(px, py);
    }
    pg.endShape(CLOSE);

    pg.popMatrix();
  }

  Individuo crossover(Individuo outro) {
    Individuo filho = new Individuo();
    for (int i = 0; i < formas.length; i++) {
      filho.formas[i].m  = random(1) < 0.5 ? this.formas[i].m  : outro.formas[i].m;
      filho.formas[i].a  = random(1) < 0.5 ? this.formas[i].a  : outro.formas[i].a;
      filho.formas[i].b  = random(1) < 0.5 ? this.formas[i].b  : outro.formas[i].b;
      filho.formas[i].n1 = random(1) < 0.5 ? this.formas[i].n1 : outro.formas[i].n1;
      filho.formas[i].n2 = random(1) < 0.5 ? this.formas[i].n2 : outro.formas[i].n2;
      filho.formas[i].n3 = random(1) < 0.5 ? this.formas[i].n3 : outro.formas[i].n3;
    }
    return filho;
  }

  void mutacao(float taxa) {
    for (Superformula f : formas) {
      if (random(1) < taxa) f.m  += round(random(-2, 2));
      if (random(1) < taxa) f.a  += random(-0.2, 0.2);
      if (random(1) < taxa) f.b  += random(-0.2, 0.2);
      if (random(1) < taxa) f.n1 += random(-0.2, 0.2);
      if (random(1) < taxa) f.n2 += random(-0.2, 0.2);
      if (random(1) < taxa) f.n3 += random(-0.2, 0.2);
    }
  }
}

void initPopulacao() {
  populacao = new ArrayList<Individuo>();
  for (int i = 0; i < tamanhoPop; i++) {
    populacao.add(new Individuo());
  }
}

Individuo selecionarRoleta() {
  float soma = 0;
  for (Individuo ind : populacao) soma += ind.fitness;

  float r = random(soma);
  float acumulado = 0;
  for (Individuo ind : populacao) {
    acumulado += ind.fitness;
    if (acumulado >= r) return ind;
  }
  return populacao.get(populacao.size()-1);
}

void novaGeracao() {
  ArrayList<Individuo> nova = new ArrayList<Individuo>();
  while (nova.size() < tamanhoPop) {
    Individuo p1 = selecionarRoleta();
    Individuo p2 = selecionarRoleta();
    Individuo filho = p1.crossover(p2);
    filho.mutacao(0.2);
    nova.add(filho);
  }
  populacao = nova;
  geracao++;
}
