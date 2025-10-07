class Superformula {
  float m, a, b, n1, n2, n3;

  Superformula(float m, float a, float b, float n1, float n2, float n3) {
    this.m = m;
    this.a = a;
    this.b = b;
    this.n1 = n1;
    this.n2 = n2;
    this.n3 = n3;
  }

  Superformula() {
    this.m  = round(random(0, 12));
    this.a  = random(0.5, 2.0);
    this.b  = random(0.5, 2.0);
    this.n1 = random(0.05, 1.5);
    this.n2 = random(0.05, 1.5);
    this.n3 = random(0.05, 1.5);
  }

  // função da superfórmula
  float formula(float theta) {
    float part1 = pow(abs((1/a) * cos(m * theta / 4)), n2);
    float part2 = pow(abs((1/b) * sin(m * theta / 4)), n3);
    float r = pow(part1 + part2, -1/n1);
    return r;
  }
}
