class Coordenadas {
  int letra;
  int numero;
  bool leftBool;
  bool rightBool;
  bool topBool;
  bool bottomBool;
  bool topLeftBool;
  bool topRightBool;
  bool bottomLeftBool;
  bool bottomRightBool;
  Coordenadas left;
  Coordenadas right;
  Coordenadas top;
  Coordenadas bottom;
  Coordenadas topLeft;
  Coordenadas topRight;
  Coordenadas bottomLeft;
  Coordenadas bottomRight;

  Coordenadas(this.letra, this.numero);

  instanciaAdj() {
    left = Coordenadas(letra, numero - 1);

    right = Coordenadas(letra, numero + 1);

    top = Coordenadas(letra - 1, numero);

    bottom = Coordenadas(letra + 1, numero);

    topLeft = Coordenadas(letra - 1, numero - 1);

    topRight = Coordenadas(letra - 1, numero + 1);

    bottomLeft = Coordenadas(letra + 1, numero - 1);

    bottomRight = Coordenadas(letra + 1, numero + 1);
  }

  verificaAdjacentes(tabuleiroTiro, tabuleiroAdj, [cod]) {
    instanciaAdj();

    leftBool = true;
    rightBool = true;
    topBool = true;
    bottomBool = true;

    if ((cod != null) && (cod == "h")) {
      topLeftBool = true;
      topRightBool = true;
      bottomLeftBool = true;
      bottomRightBool = true;

      if (((letra - 1) < 0) || ((numero + 1) > 9)) {
        topRightBool = false;
      } else if ((tabuleiroTiro[letra - 1][numero + 1] != "") ||
          (tabuleiroAdj[letra - 1][numero + 1] != "")) {
        topRightBool = false;
      }

      if (((letra - 1) < 0) || ((numero - 1) < 0)) {
        topLeftBool = false;
      } else if ((tabuleiroTiro[letra - 1][numero - 1] != "") ||
          (tabuleiroAdj[letra - 1][numero - 1] != "")) {
        topLeftBool = false;
      }

      if (((letra + 1) > 9) || ((numero + 1) > 9)) {
        bottomRightBool = false;
      } else if ((tabuleiroTiro[letra + 1][numero + 1] != "") ||
          (tabuleiroAdj[letra + 1][numero + 1] != "")) {
        bottomRightBool = false;
      }

      if (((letra + 1) > 9) || ((numero - 1) < 0)) {
        bottomLeftBool = false;
      } else if ((tabuleiroTiro[letra + 1][numero - 1] != "") ||
          (tabuleiroAdj[letra + 1][numero - 1] != "")) {
        bottomLeftBool = false;
      }
    } else {
      if ((numero + 1) > 9) {
        rightBool = false;
      } else if ((tabuleiroTiro[letra][numero + 1] != "") ||
          (tabuleiroAdj[letra][numero + 1] != "")) {
        rightBool = false;
      }

      if ((numero - 1) < 0) {
        leftBool = false;
      } else if ((tabuleiroTiro[letra][numero - 1] != "") ||
          (tabuleiroAdj[letra][numero - 1] != "")) {
        leftBool = false;
      }

      if ((letra - 1) < 0) {
        topBool = false;
      } else if ((tabuleiroTiro[letra - 1][numero] != "") ||
          (tabuleiroAdj[letra - 1][numero] != "")) {
        topBool = false;
      }

      if ((letra + 1) > 9) {
        bottomBool = false;
      } else if ((tabuleiroTiro[letra + 1][numero] != "") ||
          (tabuleiroAdj[letra + 1][numero] != "")) {
        bottomBool = false;
      }
    }
  }
}
