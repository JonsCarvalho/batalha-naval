class Naves {
  int tam;
  String nome;
  String codigo;
  int contTiros = 0;
  List<int> listaAtaquesLetra = [];
  List<int> listaAtaquesNumero = [];

  Naves(this.tam, this.nome, this.codigo);

  setAtaques(letra, numero){
    listaAtaquesLetra.add(letra);
    listaAtaquesNumero.add(numero);
  }

  posicionar(dynamic posInicialY, int posInicialX, String direcao,
      List<dynamic> tabuleiro) {
    posInicialX -= 1;

    switch (posInicialY) {
      case "A":
        posInicialY = 0;
        break;
      case "B":
        posInicialY = 1;
        break;
      case "C":
        posInicialY = 2;
        break;
      case "D":
        posInicialY = 3;
        break;
      case "E":
        posInicialY = 4;
        break;
      case "F":
        posInicialY = 5;
        break;
      case "G":
        posInicialY = 6;
        break;
      case "H":
        posInicialY = 7;
        break;
      case "I":
        posInicialY = 8;
        break;
      case "J":
        posInicialY = 9;
        break;
      case "a":
        posInicialY = 0;
        break;
      case "b":
        posInicialY = 1;
        break;
      case "c":
        posInicialY = 2;
        break;
      case "d":
        posInicialY = 3;
        break;
      case "e":
        posInicialY = 4;
        break;
      case "f":
        posInicialY = 5;
        break;
      case "g":
        posInicialY = 6;
        break;
      case "h":
        posInicialY = 7;
        break;
      case "i":
        posInicialY = 8;
        break;
      case "j":
        posInicialY = 9;
        break;
      default:
    }

    if (codigo.contains("h")) {
      switch (direcao) {
        case ">":
          tabuleiro[posInicialY][posInicialX] = "$codigo";
          tabuleiro[posInicialY + 1][posInicialX + 1] = "$codigo";
          tabuleiro[posInicialY + 2][posInicialX] = "$codigo";
          break;
        case "<":
          tabuleiro[posInicialY][posInicialX] = "$codigo";
          tabuleiro[posInicialY + 1][posInicialX - 1] = "$codigo";
          tabuleiro[posInicialY + 2][posInicialX] = "$codigo";
          break;
        case "^":
          tabuleiro[posInicialY][posInicialX] = "$codigo";
          tabuleiro[posInicialY - 1][posInicialX + 1] = "$codigo";
          tabuleiro[posInicialY][posInicialX + 2] = "$codigo";
          break;
        case "v":
          tabuleiro[posInicialY][posInicialX] = "$codigo";
          tabuleiro[posInicialY + 1][posInicialX + 1] = "$codigo";
          tabuleiro[posInicialY][posInicialX + 2] = "$codigo";
          break;
        default:
      }
    } else if (direcao == "v") {
      for (int y = posInicialY; y < (posInicialY + tam); y++) {
        tabuleiro[y][posInicialX] = "$codigo";
      }
    } else if (direcao == "h") {
      for (int x = posInicialX; x < (posInicialX + tam); x++) {
        tabuleiro[posInicialY][x] = "$codigo";
      }
    }
  }
}
