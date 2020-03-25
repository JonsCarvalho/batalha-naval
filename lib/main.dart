import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'IA/coordenadas.dart';
import 'esquadra/naves.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Batalha Naval'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageController = PageController();

  Naves portaAvioes = Naves(5, "porta-aviões", "p1"); //
  Naves cruzadores1 = Naves(4, "cruzador", "c1"); //
  Naves cruzadores2 = Naves(4, "cruzador", "c2"); //
  Naves destroyers1 = Naves(2, "destroyer", "d1"); //
  Naves destroyers2 = Naves(2, "destroyer", "d2"); //
  Naves destroyers3 = Naves(2, "destroyer", "d3"); //
  Naves submarinos1 = Naves(1, "submarino", "s1"); //  Naves do tabuleiro
  Naves submarinos2 = Naves(1, "submarino", "s2"); //  aliado
  Naves submarinos3 = Naves(1, "submarino", "s3"); //
  Naves submarinos4 = Naves(1, "submarino", "s4"); //
  Naves hidroAvioes1 = Naves(3, "hidroavião", "h1"); //
  Naves hidroAvioes2 = Naves(3, "hidroavião", "h2"); //
  Naves hidroAvioes3 = Naves(3, "hidroavião", "h3"); //
  Naves hidroAvioes4 = Naves(3, "hidroavião", "h4"); //

  Naves portaAvioesInimigo = Naves(5, "porta-aviões", "p"); //
  Naves cruzadores1Inimigo = Naves(4, "cruzador", "c"); //
  //Naves cruzadores2Inimigo = Naves(4, "cruzador", "c2i"); //
  Naves destroyers1Inimigo = Naves(2, "destroyer", "d"); //
  //Naves destroyers2Inimigo = Naves(2, "destroyer", "d2i"); //
  //Naves destroyers3Inimigo = Naves(2, "destroyer", "d3i"); //
  Naves submarinos1Inimigo = Naves(1, "submarino", "s"); //  Naves do
  // Naves submarinos2Inimigo = Naves(1, "submarino", "s2i"); //  tabuleiro
  // Naves submarinos3Inimigo = Naves(1, "submarino", "s3i"); //  inimigo
  // Naves submarinos4Inimigo = Naves(1, "submarino", "s4i"); //
  Naves hidroAvioes1Inimigo = Naves(3, "hidroavião", "h"); //
  // Naves hidroAvioes2Inimigo = Naves(3, "hidroavião", "h2i"); //
  // Naves hidroAvioes3Inimigo = Naves(3, "hidroavião", "h3i"); //
  // Naves hidroAvioes4Inimigo = Naves(3, "hidroavião", "h4i"); //
  Naves naveAux;
  Naves naveAuxAliada;
  bool botaoAtaque = true;
  bool botaoResultado = false;
  int largura = 10;
  int altura = 10;
  int tiroAnteriorLetra;
  int tiroAnteriorNumero;
  List<int> contTiros = [];
  List<dynamic> tabuleiroTirosAliado = [];
  List<dynamic> tabuleiroAliado = [];
  List<dynamic> tabuleiroTirosInimigo = [];
  List<dynamic> tabuleiroInimigo = [];
  List<dynamic> tabuleiroNavAdjInimigo = [];
  List<dynamic> tabuleiroNavAdjInimigoAux = [];
  List<dynamic> coresNav = [
    {"p1": Colors.green},
    {"p": Colors.green},
    {"c1": Colors.orange},
    {"c2": Colors.orange},
    {"c": Colors.orange},
    {"d1": Colors.purple},
    {"d2": Colors.purple},
    {"d3": Colors.purple},
    {"d": Colors.purple},
    {"s1": Colors.pink},
    {"s2": Colors.pink},
    {"s3": Colors.pink},
    {"s4": Colors.pink},
    {"s": Colors.pink},
    {"h1": Colors.yellow},
    {"h2": Colors.yellow},
    {"h3": Colors.yellow},
    {"h4": Colors.yellow},
    {"h": Colors.yellow},
  ];
  int selectedLetra;
  int selectedNumero;
  int selectedLetraIA;
  int selectedNumeroIA;
  String selectedNave;
  List<String> navesAtingidos = [];
  List<int> navesAtingidosCoordLetra = [];
  List<int> navesAtingidosCoordNumero = [];
  List<int> navesDestruidos = [];
  int portavioes = 1;
  int cruzadores = 2;
  int destroyers = 3;
  int submarinos = 4;
  int hidroavioes = 4;

  int portavioesIa = 1;
  int cruzadoresIa = 2;
  int destroyersIa = 3;
  int submarinosIa = 4;
  int hidroavioesIa = 4;

  List<DropdownMenuItem<int>> listDropLetra = [];
  List<DropdownMenuItem<int>> listDropNumero = [];
  List<DropdownMenuItem<String>> listDropNave = [];
  Coordenadas coord;
  Coordenadas coordRaiz;
  bool isHorizontal = false;
  bool isVertical = false;
  bool isHidroTwo = false;
  bool checkBack = false;
  int contJogadas = 3;
  int _rand;

  List<int> quadrantesIa = [0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    inicializaTabuleiro(tabuleiroAliado);
    inicializaTabuleiro(tabuleiroTirosAliado);
    inicializaTabuleiro(tabuleiroInimigo);
    inicializaTabuleiro(tabuleiroTirosInimigo);
    inicializaTabuleiro(tabuleiroNavAdjInimigo);
    inicializaTabuleiro(tabuleiroNavAdjInimigoAux);
    instanciaNaves();
  }

  loadData() {
    listDropLetra = [];
    listDropNumero = [];

    listDropLetra.add(DropdownMenuItem(
      child: Text("A"),
      value: 0,
    ));
    listDropLetra.add(DropdownMenuItem(
      child: Text("B"),
      value: 1,
    ));
    listDropLetra.add(DropdownMenuItem(
      child: Text("C"),
      value: 2,
    ));
    listDropLetra.add(DropdownMenuItem(
      child: Text("D"),
      value: 3,
    ));
    listDropLetra.add(DropdownMenuItem(
      child: Text("E"),
      value: 4,
    ));
    listDropLetra.add(DropdownMenuItem(
      child: Text("F"),
      value: 5,
    ));
    listDropLetra.add(DropdownMenuItem(
      child: Text("G"),
      value: 6,
    ));
    listDropLetra.add(DropdownMenuItem(
      child: Text("H"),
      value: 7,
    ));
    listDropLetra.add(DropdownMenuItem(
      child: Text("I"),
      value: 8,
    ));
    listDropLetra.add(DropdownMenuItem(
      child: Text("J"),
      value: 9,
    ));

    listDropNumero.add(DropdownMenuItem(
      child: Text("1"),
      value: 0,
    ));
    listDropNumero.add(DropdownMenuItem(
      child: Text("2"),
      value: 1,
    ));
    listDropNumero.add(DropdownMenuItem(
      child: Text("3"),
      value: 2,
    ));
    listDropNumero.add(DropdownMenuItem(
      child: Text("4"),
      value: 3,
    ));
    listDropNumero.add(DropdownMenuItem(
      child: Text("5"),
      value: 4,
    ));
    listDropNumero.add(DropdownMenuItem(
      child: Text("6"),
      value: 5,
    ));
    listDropNumero.add(DropdownMenuItem(
      child: Text("7"),
      value: 6,
    ));
    listDropNumero.add(DropdownMenuItem(
      child: Text("8"),
      value: 7,
    ));
    listDropNumero.add(DropdownMenuItem(
      child: Text("9"),
      value: 8,
    ));
    listDropNumero.add(DropdownMenuItem(
      child: Text("10"),
      value: 9,
    ));
  }

  loadDataIA() {
    listDropNave = [];

    listDropNave.add(DropdownMenuItem(
      child: Text("Água"),
      value: "",
    ));
    listDropNave.add(DropdownMenuItem(
      child: Text("Porta-Aviões"),
      value: "p",
    ));
    listDropNave.add(DropdownMenuItem(
      child: Text("Cruzador"),
      value: "c",
    ));
    listDropNave.add(DropdownMenuItem(
      child: Text("Destroyer"),
      value: "d",
    ));
    listDropNave.add(DropdownMenuItem(
      child: Text("Hidroavião"),
      value: "h",
    ));
    listDropNave.add(DropdownMenuItem(
      child: Text("Submarino"),
      value: "s",
    ));
  }

  inicializaTabuleiro(tabuleiroAliado) {
    setState(() {
      tabuleiroAliado.clear();
      for (int i = 0; i < altura; i++) {
        tabuleiroAliado.insert(i, [
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
        ]);
      }
    });
  }

  instanciaNaves() {
    setState(() {
      int aux = _rand;

      while (aux == _rand) {
        _rand = Random(DateTime.now().millisecondsSinceEpoch).nextInt(3);
      }
    });

    inicializaTabuleiro(tabuleiroAliado);

    switch (_rand) {
      case 0:
        portaAvioes.posicionar("d", 2, "v", tabuleiroAliado);
        cruzadores1.posicionar("d", 7, "h", tabuleiroAliado);
        cruzadores2.posicionar("j", 1, "h", tabuleiroAliado);
        destroyers1.posicionar("A", 10, "v", tabuleiroAliado);
        destroyers2.posicionar("e", 4, "h", tabuleiroAliado);
        destroyers3.posicionar("h", 9, "h", tabuleiroAliado);
        submarinos1.posicionar("f", 8, "h", tabuleiroAliado);
        submarinos2.posicionar("a", 8, "v", tabuleiroAliado);
        submarinos3.posicionar("f", 10, "v", tabuleiroAliado);
        submarinos4.posicionar("J", 10, "h", tabuleiroAliado);
        hidroAvioes1.posicionar("g", 4, "v", tabuleiroAliado);
        hidroAvioes2.posicionar("A", 5, ">", tabuleiroAliado);
        hidroAvioes3.posicionar("J", 6, "^", tabuleiroAliado);
        hidroAvioes4.posicionar("b", 1, "^", tabuleiroAliado);
        break;
      case 1:
        portaAvioes.posicionar("c", 1, "v", tabuleiroAliado);
        cruzadores1.posicionar("e", 7, "h", tabuleiroAliado);
        cruzadores2.posicionar("j", 5, "h", tabuleiroAliado);
        destroyers1.posicionar("A", 3, "v", tabuleiroAliado);
        destroyers2.posicionar("a", 5, "v", tabuleiroAliado);
        destroyers3.posicionar("g", 10, "v", tabuleiroAliado);
        submarinos1.posicionar("j", 10, "h", tabuleiroAliado);
        submarinos2.posicionar("j", 1, "v", tabuleiroAliado);
        submarinos3.posicionar("a", 10, "v", tabuleiroAliado);
        submarinos4.posicionar("a", 1, "h", tabuleiroAliado);
        hidroAvioes1.posicionar("c", 7, "^", tabuleiroAliado);
        hidroAvioes2.posicionar("g", 3, ">", tabuleiroAliado);
        hidroAvioes3.posicionar("d", 3, "v", tabuleiroAliado);
        hidroAvioes4.posicionar("g", 6, "v", tabuleiroAliado);
        break;
      case 2:
        portaAvioes.posicionar("a", 6, "h", tabuleiroAliado);
        cruzadores1.posicionar("d", 5, "h", tabuleiroAliado);
        cruzadores2.posicionar("c", 1, "v", tabuleiroAliado);
        destroyers1.posicionar("i", 1, "v", tabuleiroAliado);
        destroyers2.posicionar("j", 3, "h", tabuleiroAliado);
        destroyers3.posicionar("c", 10, "v", tabuleiroAliado);
        submarinos1.posicionar("a", 1, "h", tabuleiroAliado);
        submarinos2.posicionar("j", 10, "v", tabuleiroAliado);
        submarinos3.posicionar("f", 7, "v", tabuleiroAliado);
        submarinos4.posicionar("e", 3, "h", tabuleiroAliado);
        hidroAvioes1.posicionar("a", 3, ">", tabuleiroAliado);
        hidroAvioes2.posicionar("g", 3, "v", tabuleiroAliado);
        hidroAvioes3.posicionar("i", 6, "^", tabuleiroAliado);
        hidroAvioes4.posicionar("f", 10, "<", tabuleiroAliado);
        break;
      default:
    }
  }

  _color(i, j, tabuleiro) {
    // ((tiro.toString() == "[$i, $j]") || (tabuleiroTirosAliado[i][j] == "x")) {
    String codigo = tabuleiro[i][j].toString();
    bool aux = false;

    if ((_pageController.page == 2) || (_pageController.page == 4)) {
      for (int index = 0; index < coresNav.length; index++) {
        if (coresNav[index][codigo.toString()] != null) {
          aux = true;
          return coresNav[index][codigo.toString()] as Color;
        }
      }
    } else if (_pageController.page == 3) {
      for (int index = 0; index < coresNav.length; index++) {
        if (coresNav[index][codigo.toString()] != null) {
          aux = true;
          return coresNav[index][codigo.toString()] as Color;
        }
      }
    }

    if (!aux) {
      return Colors.cyan;
    }
  }

  changePage(i) {
    setState(() {
      if (contJogadas == 0) {
        contJogadas = 3;
        _pageController.jumpToPage(i);
      }
    });
  }

  Widget tiles(i, j, tabuleiroTiros, tabuleiro) {
    if (tabuleiroTiros[i][j] == "x") {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          //color: Colors.deepOrangeAccent
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   tabuleiro[i][j],
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 15,
            //   ),
            // ),
            Image.asset(
              "images/bomb.png",
              scale: 25,
            ),
          ],
        ),
      );
    } else {
      return Text(""); //Text(tabuleiroNavAdjInimigo[i][j].toString());
    }
  }

  _submit() {
    if ((selectedLetraIA != null) && (selectedNumeroIA != null)) {
      setState(() {
        tabuleiroTirosInimigo[selectedLetraIA][selectedNumeroIA] = "x";
      });
    }

    if ((selectedLetraIA != null) &&
        (selectedNumeroIA != null) &&
        (selectedNave != null)) {
      setState(() {
        tabuleiroInimigo[selectedLetraIA][selectedNumeroIA] =
            selectedNave.toString();
        showDialog(
            context: context,
            builder: (context) {
              contJogadas--;

              return AlertDialog(
                content: Text(_getResultadoIA(tabuleiroInimigo).toString()),
              );
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData();

    return PageView(
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.cyan,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "BATALHA NAVAL DE I.A.'s",
                    style: TextStyle(fontFamily: 'Courier New', fontSize: 30),
                  ),
                ),
                Center(
                  child: OutlineButton(
                    onPressed: () {
                      _pageController.jumpToPage(4);
                    },
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    highlightedBorderColor: Colors.cyan,
                    splashColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "INICIAR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Desenvolvido por Jônatas Moreira de Carvalho\nPara a disciplina de Inteligência Artificial\nCurso de Ciência da Computação\nUniversidade Estadual de Santa Cruz - UESC",
                  style: TextStyle(
                    fontFamily: 'Courier New',
                  ),
                ),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.cyan,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "QUEM VAI COMEÇAR?",
                    style: TextStyle(fontFamily: 'Courier New', fontSize: 30),
                  ),
                ),
                Center(
                  child: FlatButton(
                    onPressed: () {
                      _pageController.jumpToPage(3);
                    },
                    color: Colors.black,
                    child: Text(
                      "VOCÊ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: FlatButton(
                    onPressed: () {
                      _pageController.jumpToPage(2);
                    },
                    color: Colors.black,
                    child: Text(
                      "INIMIGO",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: FlatButton(
                    onPressed: () {
                      int rand;

                      rand = Random(DateTime.now().millisecondsSinceEpoch)
                          .nextInt(2);
                      if (rand == 0) {
                        _pageController.jumpToPage(2);
                      } else {
                        _pageController.jumpToPage(3);
                      }
                    },
                    color: Colors.black,
                    child: Text(
                      "RANDOM",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.white.withOpacity(.9),
          appBar: AppBar(
            leading: FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => new MyApp(),
                  ),
                );
                //_pageController.jumpToPage(0);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              "SEU ESQUADRÃO",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 2,
              ),
            ),
            actions: <Widget>[
              Text(
                "${contJogadas.toString()} Tiros restantes".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 2,
                ),
              ),
            ],
            backgroundColor: Colors.red,
          ),
          body: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 8, left: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: 11,
                          itemBuilder: (BuildContext context, int i) {
                            return Row(
                              children: <Widget>[
                                _getNumeros(i),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 17,
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          scrollDirection: Axis.vertical,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int i) {
                            int j = 0;

                            return Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  height: 23,
                                  width: 23,
                                  child: Card(
                                    margin: EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    //elevation: 2,
                                    color: Colors.black,
                                    child: Center(
                                      child: Text(
                                        _getLetras(i),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                _getLinha(i, j + 0, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 1, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 2, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 3, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 4, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 5, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 6, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 7, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 8, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 9, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: ((submarinos == 0) &&
                        (destroyers == 0) &&
                        (hidroavioes == 0) &&
                        (cruzadores == 0) &&
                        (portavioes == 0))
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "FIM DE JOGO!",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "Você perdeu :(",
                            style: TextStyle(fontSize: 15, letterSpacing: 2),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 20,
                                width: 20,
                                color: Colors.pink,
                              ),
                              Text(
                                "${submarinos.toString()} SUBMARINOS",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 20,
                                    width: 20,
                                    color: Colors.purple,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    color: Colors.purple,
                                  ),
                                ],
                              ),
                              Text(
                                "${destroyers.toString()} DESTROYERS",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 42),
                                height: 20,
                                width: 20,
                                color: Colors.yellow,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        width: 20,
                                        color: Colors.yellow,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        color: Colors.yellow,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${hidroavioes.toString()} HIDROAVIOES",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                              Text(
                                "${cruzadores.toString()} CRUZADORES",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                              Text(
                                "${portavioes.toString()} PORTA-AVIÕES",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              Expanded(
                flex: 2,
                child: ((submarinos == 0) &&
                        (destroyers == 0) &&
                        (hidroavioes == 0) &&
                        (cruzadores == 0) &&
                        (portavioes == 0))
                    ? SizedBox()
                    : contJogadas == 0
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: FlatButton(
                              onPressed: () {
                                changePage(3);
                              },
                              color: Colors.red,
                              child: Text(
                                "SUA VEZ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : Card(
                            elevation: 34,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    "ATAQUE INIMIGO:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      //backgroundColor: Colors.red,
                                    ),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      items: listDropLetra,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                      value: selectedLetra,
                                      iconSize: 30,
                                      elevation: 16,
                                      hint: Text(
                                        "LETRA",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        selectedLetra = value;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      items: listDropNumero,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                      value: selectedNumero,
                                      iconSize: 30,
                                      elevation: 16,
                                      hint: Text(
                                        "NÚMERO",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        selectedNumero = value;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        tabuleiroTirosAliado[selectedLetra]
                                            [selectedNumero] = "x";
                                        _showDialog(tabuleiroAliado);
                                      });
                                    },
                                    color: Colors.red,
                                    child: Text(
                                      "OK",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
        Scaffold(
          backgroundColor: Colors.white.withOpacity(.9),
          appBar: AppBar(
            leading: FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => new MyApp(),
                  ),
                );
                //_pageController.jumpToPage(0);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              "ESQUADRÃO INIMIGO",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 2,
              ),
            ),
            actions: <Widget>[
              Text(
                "${contJogadas.toString()} Tiros restantes".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 2,
                ),
              ),
            ],
            backgroundColor: Colors.black,
          ),
          body: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 7, left: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: 11,
                          itemBuilder: (BuildContext context, int i) {
                            return Row(
                              children: <Widget>[
                                _getNumeros(i),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 17,
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          scrollDirection: Axis.vertical,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int i) {
                            int j = 0;

                            return Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  height: 23,
                                  width: 23,
                                  child: Card(
                                    margin: EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    //elevation: 2,
                                    color: Colors.black,
                                    child: Center(
                                      child: Text(
                                        _getLetras(i),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                _getLinha(i, j + 0, tabuleiroTirosInimigo,
                                    tabuleiroInimigo),
                                _getLinha(i, j + 1, tabuleiroTirosInimigo,
                                    tabuleiroInimigo),
                                _getLinha(i, j + 2, tabuleiroTirosInimigo,
                                    tabuleiroInimigo),
                                _getLinha(i, j + 3, tabuleiroTirosInimigo,
                                    tabuleiroInimigo),
                                _getLinha(i, j + 4, tabuleiroTirosInimigo,
                                    tabuleiroInimigo),
                                _getLinha(i, j + 5, tabuleiroTirosInimigo,
                                    tabuleiroInimigo),
                                _getLinha(i, j + 6, tabuleiroTirosInimigo,
                                    tabuleiroInimigo),
                                _getLinha(i, j + 7, tabuleiroTirosInimigo,
                                    tabuleiroInimigo),
                                _getLinha(i, j + 8, tabuleiroTirosInimigo,
                                    tabuleiroInimigo),
                                _getLinha(i, j + 9, tabuleiroTirosInimigo,
                                    tabuleiroInimigo),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: ((submarinosIa == 0) &&
                        (destroyersIa == 0) &&
                        (hidroavioesIa == 0) &&
                        (cruzadoresIa == 0) &&
                        (portavioesIa == 0))
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "FIM DE JOGO!",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "Você venceu :)",
                            style: TextStyle(fontSize: 15, letterSpacing: 2),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 20,
                                width: 20,
                                color: Colors.pink,
                              ),
                              Text(
                                "${submarinosIa.toString()} SUBMARINOS",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 20,
                                    width: 20,
                                    color: Colors.purple,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    color: Colors.purple,
                                  ),
                                ],
                              ),
                              Text(
                                "${destroyersIa.toString()} DESTROYERS",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 42),
                                height: 20,
                                width: 20,
                                color: Colors.yellow,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        width: 20,
                                        color: Colors.yellow,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        color: Colors.yellow,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${hidroavioesIa.toString()} HIDROAVIOES",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                              Text(
                                "${cruzadoresIa.toString()} CRUZADORES",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                              Text(
                                "${portavioesIa.toString()} PORTA-AVIÕES",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: ((submarinosIa == 0) &&
                          (destroyersIa == 0) &&
                          (hidroavioesIa == 0) &&
                          (cruzadoresIa == 0) &&
                          (portavioesIa == 0))
                      ? SizedBox()
                      : contJogadas == 0
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: FlatButton(
                                onPressed: () {
                                  changePage(2);
                                },
                                color: Colors.black,
                                child: Text(
                                  "VEZ DO INIMIGO",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : Card(
                              elevation: 34,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // RaisedButton(
                                    //   onPressed: () {
                                    //     setState(() {
                                    //       _ataqueIA();
                                    //     });
                                    //   },
                                    //   color: Colors.black,
                                    //   child: Text(
                                    //     "Atacar I.A. inimiga".toUpperCase(),
                                    //     style: TextStyle(
                                    //         fontSize: 12,
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.normal),
                                    //   ),
                                    // ),
                                    Text(
                                      "ATACAR I.A. INIMIGA:",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        //backgroundColor: Colors.red,
                                      ),
                                    ),
                                    selectedLetraIA == null
                                        ? Text("LETRA")
                                        : Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 30),
                                            height: 30,
                                            child: Card(
                                              //margin: EdgeInsets.symmetric(horizontal: 50),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              color: Colors.cyan,
                                              elevation: 15,
                                              child: Center(
                                                child: Text(
                                                  _getLetras(selectedLetraIA),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    // DropdownButtonHideUnderline(
                                    //   child: DropdownButton(
                                    //     items: listDropLetra,
                                    //     style:
                                    //         TextStyle(color: Colors.black, fontSize: 12),
                                    //     value: selectedLetraIA,
                                    //     iconSize: 30,
                                    //     elevation: 16,
                                    //     hint: Text(
                                    //       "LETRA",
                                    //       style: TextStyle(
                                    //         color: Colors.black,
                                    //       ),
                                    //     ),
                                    //     onChanged: (value) {
                                    //       selectedLetraIA = value;
                                    //       setState(() {});
                                    //     },
                                    //   ),
                                    // ),
                                    selectedLetraIA == null
                                        ? Text("NÚMERO")
                                        : Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 30),
                                            height: 30,
                                            child: Card(
                                              //margin: EdgeInsets.symmetric(horizontal: 50),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              color: Colors.cyan,
                                              elevation: 15,
                                              child: Center(
                                                child: Text(
                                                  (selectedNumeroIA + 1)
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    // DropdownButtonHideUnderline(
                                    //   child: DropdownButton(
                                    //     items: listDropNumero,
                                    //     style:
                                    //         TextStyle(color: Colors.black, fontSize: 12),
                                    //     value: selectedNumeroIA,
                                    //     iconSize: 30,
                                    //     elevation: 16,
                                    //     hint: Text(
                                    //       "NÚMERO",
                                    //       style: TextStyle(
                                    //         color: Colors.black,
                                    //       ),
                                    //     ),
                                    //     onChanged: (value) {
                                    //       selectedNumeroIA = value;
                                    //       setState(() {});
                                    //     },
                                    //   ),
                                    // ),
                                    _showButtons(tabuleiroInimigo,
                                        selectedLetraIA, selectedNumeroIA),
                                  ],
                                ),
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
        Scaffold(
          backgroundColor: Colors.cyan.shade200,
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            leading: FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => new MyApp(),
                  ),
                );
                //_pageController.jumpToPage(0);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              "ESSA É A DISPOSIÇÃO DOS SEUS NAVIOS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 2,
              ),
            ),
          ),
          body: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 8, left: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: 11,
                          itemBuilder: (BuildContext context, int i) {
                            return Row(
                              children: <Widget>[
                                _getNumeros(i),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 17,
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          scrollDirection: Axis.vertical,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int i) {
                            int j = 0;

                            return Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  height: 23,
                                  width: 23,
                                  child: Card(
                                    margin: EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    //elevation: 2,
                                    color: Colors.black,
                                    child: Center(
                                      child: Text(
                                        _getLetras(i),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                _getLinha(i, j + 0, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 1, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 2, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 3, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 4, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 5, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 6, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 7, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 8, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                                _getLinha(i, j + 9, tabuleiroTirosAliado,
                                    tabuleiroAliado),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        color: Colors.red,
                        onPressed: () {
                          instanciaNaves();
                        },
                        child: Text(
                          "OUTRO",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FlatButton(
                        color: Colors.black,
                        onPressed: () {
                          _pageController.jumpToPage(1);
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _showDialog(tabuleiro) {
    loadData();
    contJogadas--;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
          content: Container(
            height: 50,
            child: Column(
              children: <Widget>[
                Text(_getResultado(tabuleiro).toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getResultado(tabuleiro) {
    if ((selectedLetra != null) && (selectedNumero != null)) {
      if (tabuleiro[selectedLetra][selectedNumero] != "") {
        String cod = tabuleiro[selectedLetra][selectedNumero].toString();
        naveAuxAliada = _getNave(cod);

        naveAuxAliada.contTiros++;

        selectedLetra = null;
        selectedNumero = null;

        if (naveAuxAliada.contTiros == naveAuxAliada.tam) {
          switch (naveAuxAliada.nome.substring(0, 1)) {
            case "s":
              submarinos--;
              break;
            case "d":
              destroyers--;
              break;
            case "h":
              hidroavioes--;
              break;
            case "c":
              cruzadores--;
              break;
            case "p":
              portavioes--;
              break;
            default:
          }
          return "Um ${naveAuxAliada.nome} foi destruído!";
        } else {
          return "Acertou um ${naveAuxAliada.nome}!";
        }
      } else {
        selectedLetra = null;
        selectedNumero = null;
        return "Tiro na água!";
      }
    } else {
      return "";
    }
  }

  _getNave(codigo) {
    switch (codigo) {
      case "p1":
        return portaAvioes;
        break;
      case "c1":
        return cruzadores1;
        break;
      case "c2":
        return cruzadores2;
        break;
      case "d1":
        return destroyers1;
        break;
      case "d2":
        return destroyers2;
        break;
      case "d3":
        return destroyers3;
        break;
      case "s1":
        return submarinos1;
        break;
      case "s2":
        return submarinos2;
        break;
      case "s3":
        return submarinos3;
        break;
      case "s4":
        return submarinos4;
        break;
      case "h1":
        return hidroAvioes1;
        break;
      case "h2":
        return hidroAvioes2;
        break;
      case "h3":
        return hidroAvioes3;
        break;
      case "h4":
        return hidroAvioes4;
        break;
      case "p":
        return portaAvioesInimigo;
        break;
      case "c":
        return cruzadores1Inimigo;
        break;
      // case "c2i":
      //   return cruzadores2Inimigo;
      //   break;
      case "d":
        return destroyers1Inimigo;
        break;
      // case "d2i":
      //   return destroyers2Inimigo;
      //   break;
      // case "d3i":
      //   return destroyers3Inimigo;
      //   break;
      case "s":
        return submarinos1Inimigo;
        break;
      // case "s2i":
      //   return submarinos2Inimigo;
      //   break;
      // case "s3i":
      //   return submarinos3Inimigo;
      //   break;
      // case "s4i":
      //   return submarinos4Inimigo;
      //   break;
      case "h":
        return hidroAvioes1Inimigo;
        break;
      // case "h2i":
      //   return hidroAvioes2Inimigo;
      //   break;
      // case "h3i":
      //   return hidroAvioes3Inimigo;
      //   break;
      // case "h4i":
      //   return hidroAvioes4Inimigo;
      //   break;
    }
  }

  _getLinha(i, j, tabuleiroTiros, tabuleiro) {
    return Container(
      margin: EdgeInsets.all(0),
      color: Colors.transparent,
      height: 23,
      width: 23,
      child: Card(
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        //elevation: 2,
        color: _color(i, j, tabuleiro),
        child: InkWell(
          onTap: () {
            setState(() {
              // Naves naveAuxAliada = _getNave(tabuleiroAliado[i][j]);
              // naveAuxAliada.contTiros++;
              if ((contJogadas != 0) && (_pageController.page != 3)) {
                if (_pageController.page != 4) {
                  selectedLetra = i;
                  selectedNumero = j;
                  tabuleiroTiros[i][j] = "x";
                  _showDialog(tabuleiro);
                }
              }
            });
          },
          child: Center(
            child: tiles(i, j, tabuleiroTiros, tabuleiro),
          ),
        ),
      ),
    );
  }

  _getLetras(i) {
    String letra;
    switch (i) {
      case 0:
        letra = "A";
        break;
      case 1:
        letra = "B";
        break;
      case 2:
        letra = "C";
        break;
      case 3:
        letra = "D";
        break;
      case 4:
        letra = "E";
        break;
      case 5:
        letra = "F";
        break;
      case 6:
        letra = "G";
        break;
      case 7:
        letra = "H";
        break;
      case 8:
        letra = "I";
        break;
      case 9:
        letra = "J";
        break;
    }

    return letra;
  }

  _getNumeros(i) {
    return Container(
      margin: EdgeInsets.all(0),
      color: Colors.transparent,
      height: 23,
      width: 23,
      child: Card(
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        //elevation: 2,
        color: Colors.black,
        child: Center(
          child: i == 0
              ? Text("")
              : Text(
                  i.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  int _getQuadrante(letra, numero) {
    if (letra < 5) {
      if (numero < 5) {
        return 0;
      } else {
        return 1;
      }
    } else {
      if (numero < 5) {
        return 2;
      } else {
        return 3;
      }
    }
  }

  _ataqueIA() {
    //int quantAtaques = 3;

    setState(() {
      Map<String, int> minQuadrante = {"index": 0, "min": quadrantesIa[0]};
      for (int z = 0; z < 4; z++) {
        if (quadrantesIa[z] < minQuadrante["min"]) {
          minQuadrante["index"] = z;
          minQuadrante["min"] = quadrantesIa[z].toInt();
        }
      }

      if (navesAtingidos.isEmpty) {
        do {
          selectedCoord(
              Random(DateTime.now().microsecondsSinceEpoch).nextInt(10),
              Random(DateTime.now().second).nextInt(10));
        } while (
            (tabuleiroTirosInimigo[selectedLetraIA][selectedNumeroIA] == "x") ||
                (tabuleiroNavAdjInimigo[selectedLetraIA][selectedNumeroIA] ==
                    "x") ||
                (minQuadrante["index"] !=
                    _getQuadrante(selectedLetraIA, selectedNumeroIA)));
        print("rand");
        if (selectedLetraIA < 5) {
          if (selectedNumeroIA < 5) {
            quadrantesIa[0]++;
          } else {
            quadrantesIa[1]++;
          }
        } else {
          if (selectedNumeroIA < 5) {
            quadrantesIa[2]++;
          } else {
            quadrantesIa[3]++;
          }
        }
        coordRaiz = Coordenadas(selectedLetraIA, selectedNumeroIA);
        isHorizontal = false;
        isVertical = false;
        isHidroTwo = false;
      } else {
        coord.verificaAdjacentes(tabuleiroTirosInimigo, tabuleiroNavAdjInimigo);
        coordRaiz.verificaAdjacentes(
            tabuleiroTirosInimigo, tabuleiroNavAdjInimigo);

        if (isHorizontal) {
          if (checkBack) {
            checkBack = false;
            coordRaiz.verificaAdjacentes(
                tabuleiroTirosInimigo, tabuleiroNavAdjInimigo);
            if (coordRaiz.leftBool
                // &&
                //     (tabuleiroNavAdjInimigo[coordRaiz.left.letra]
                //             [coordRaiz.left.numero] !=
                //         "x")
                ) {
              selectedCoord(coordRaiz.left.letra, coordRaiz.left.numero);
            } else if (coordRaiz.rightBool
                // &&
                //     (tabuleiroNavAdjInimigo[coordRaiz.right.letra]
                //             [coordRaiz.right.numero] !=
                //         "x")
                ) {
              selectedCoord(coordRaiz.right.letra, coordRaiz.right.numero);
            }
          } else if (coord.leftBool
              // &&
              //     (tabuleiroNavAdjInimigo[coord.left.letra][coord.left.numero] !=
              //         "x")
              ) {
            selectedCoord(coord.left.letra, coord.left.numero);
          } else if (coord.rightBool
              // &&
              //     (tabuleiroNavAdjInimigo[coord.right.letra][coord.right.numero] !=
              //         "x")
              ) {
            selectedCoord(coord.right.letra, coord.right.numero);
          } else {
            coordRaiz.verificaAdjacentes(
                tabuleiroTirosInimigo, tabuleiroNavAdjInimigo);
            if (coordRaiz.leftBool
                // &&
                //     (tabuleiroNavAdjInimigo[coordRaiz.left.letra]
                //             [coordRaiz.left.numero] !=
                //         "x")
                ) {
              selectedCoord(coordRaiz.left.letra, coordRaiz.left.numero);
            } else if (coordRaiz.rightBool
                // &&
                //     (tabuleiroNavAdjInimigo[coordRaiz.right.letra]
                //             [coordRaiz.right.numero] !=
                //         "x")
                ) {
              selectedCoord(coordRaiz.right.letra, coordRaiz.right.numero);
            }
          }
        } else if (isVertical) {
          if (checkBack) {
            checkBack = false;
            coordRaiz.verificaAdjacentes(
                tabuleiroTirosInimigo, tabuleiroNavAdjInimigo);
            if (coordRaiz.topBool
                // &&
                //     (tabuleiroNavAdjInimigo[coordRaiz.top.letra]
                //             [coordRaiz.top.numero] !=
                //         "x")
                ) {
              selectedCoord(coordRaiz.top.letra, coordRaiz.top.numero);
            } else if (coordRaiz.bottomBool
                // &&
                //     (tabuleiroNavAdjInimigo[coordRaiz.bottom.letra]
                //             [coordRaiz.bottom.numero] !=
                //         "x")
                ) {
              selectedCoord(coordRaiz.bottom.letra, coordRaiz.bottom.numero);
            }
          } else if (coord.topBool
              // &&
              //     (tabuleiroNavAdjInimigo[coord.top.letra][coord.top.numero] !=
              //         "x")
              ) {
            selectedCoord(coord.top.letra, coord.top.numero);
          } else if (coord.bottomBool
              // &&
              //     (tabuleiroNavAdjInimigo[coord.bottom.letra]
              //             [coord.bottom.numero] !=
              //         "x")
              ) {
            selectedCoord(coord.bottom.letra, coord.bottom.numero);
          } else {
            coordRaiz.verificaAdjacentes(
                tabuleiroTirosInimigo, tabuleiroNavAdjInimigo);
            if (coordRaiz.topBool
                // &&
                //     (tabuleiroNavAdjInimigo[coordRaiz.top.letra]
                //             [coordRaiz.top.numero] !=
                //         "x")
                ) {
              selectedCoord(coordRaiz.top.letra, coordRaiz.top.numero);
            } else if (coordRaiz.bottomBool
                // &&
                //     (tabuleiroNavAdjInimigo[coordRaiz.bottom.letra]
                //             [coordRaiz.bottom.numero] !=
                //         "x")
                ) {
              selectedCoord(coordRaiz.bottom.letra, coordRaiz.bottom.numero);
            }
          }
        } else {
          coordRaiz.verificaAdjacentes(
              tabuleiroTirosInimigo, tabuleiroNavAdjInimigo, naveAux.codigo);
          coord.verificaAdjacentes(
              tabuleiroTirosInimigo, tabuleiroNavAdjInimigo, naveAux.codigo);

          if (naveAux.codigo == "h") {
            if (isHidroTwo) {
              print("AQUI X");
              coord = Coordenadas(navesAtingidosCoordLetra.last,
                  navesAtingidosCoordNumero.last);
              coord.verificaAdjacentes(tabuleiroTirosInimigo,
                  tabuleiroNavAdjInimigo, naveAux.codigo);
              if ((coord.topLeft.letra == coordRaiz.letra) &&
                  (coord.topLeft.numero == coordRaiz.numero)) {
                coord.bottomRightBool = false;
              } else if ((coord.topRight.letra == coordRaiz.letra) &&
                  (coord.topRight.numero == coordRaiz.numero)) {
                coord.bottomLeftBool = false;
              } else if ((coord.bottomLeft.letra == coordRaiz.letra) &&
                  (coord.bottomLeft.numero == coordRaiz.numero)) {
                coord.topRightBool = false;
              } else if ((coord.bottomRight.letra == coordRaiz.letra) &&
                  (coord.bottomRight.numero == coordRaiz.numero)) {
                coord.topLeftBool = false;
              }

              if ((coordRaiz.topLeft.letra == coord.letra) &&
                  (coordRaiz.topLeft.numero == coord.numero)) {
                coordRaiz.bottomRightBool = false;
              } else if ((coordRaiz.topRight.letra == coord.letra) &&
                  (coordRaiz.topRight.numero == coord.numero)) {
                coordRaiz.bottomLeftBool = false;
              } else if ((coordRaiz.bottomLeft.letra == coord.letra) &&
                  (coordRaiz.bottomLeft.numero == coord.numero)) {
                coordRaiz.topRightBool = false;
              } else if ((coordRaiz.bottomRight.letra == coord.letra) &&
                  (coordRaiz.bottomRight.numero == coord.numero)) {
                coordRaiz.topLeftBool = false;
              }

              if (coord.topLeftBool) {
                print("AQUI 1");
                selectedCoord(coord.topLeft.letra, coord.topLeft.numero);
              } else if (coord.topRightBool) {
                print("AQUI 2");
                selectedCoord(coord.topRight.letra, coord.topRight.numero);
              } else if (coord.bottomLeftBool) {
                print("AQUI 3");
                selectedCoord(coord.bottomLeft.letra, coord.bottomLeft.numero);
              } else if (coord.bottomRightBool) {
                print("AQUI 4");
                selectedCoord(
                    coord.bottomRight.letra, coord.bottomRight.numero);
              } else if (coordRaiz.topLeftBool) {
                print("AQUI (1)");
                selectedCoord(
                    coordRaiz.topLeft.letra, coordRaiz.topLeft.numero);
              } else if (coordRaiz.topRightBool) {
                print("AQUI (2)");
                selectedCoord(
                    coordRaiz.topRight.letra, coordRaiz.topRight.numero);
              } else if (coordRaiz.bottomLeftBool) {
                print("AQUI (3)");
                selectedCoord(
                    coordRaiz.bottomLeft.letra, coordRaiz.bottomLeft.numero);
              } else if (coordRaiz.bottomRightBool) {
                print("AQUI (4)");
                selectedCoord(
                    coordRaiz.bottomRight.letra, coordRaiz.bottomRight.numero);
              }
            } else if (coordRaiz.topLeftBool) {
              print("AQUI (1)");
              selectedCoord(coordRaiz.topLeft.letra, coordRaiz.topLeft.numero);
            } else if (coordRaiz.topRightBool) {
              print("AQUI (2)");
              selectedCoord(
                  coordRaiz.topRight.letra, coordRaiz.topRight.numero);
            } else if (coordRaiz.bottomLeftBool) {
              print("AQUI (3)");
              selectedCoord(
                  coordRaiz.bottomLeft.letra, coordRaiz.bottomLeft.numero);
            } else if (coordRaiz.bottomRightBool) {
              print("AQUI (4)");
              selectedCoord(
                  coordRaiz.bottomRight.letra, coordRaiz.bottomRight.numero);
            }
          } else if (coordRaiz.leftBool
              //  &&
              //     (tabuleiroNavAdjInimigo[coordRaiz.left.letra]
              //             [coordRaiz.left.numero] !=
              //         "x")
              ) {
            selectedCoord(coordRaiz.left.letra, coordRaiz.left.numero);
          } else if (coordRaiz.rightBool
              // &&
              //     (tabuleiroNavAdjInimigo[coordRaiz.right.letra]
              //             [coordRaiz.right.numero] !=
              //         "x")
              ) {
            selectedCoord(coordRaiz.right.letra, coordRaiz.right.numero);
          } else if (coordRaiz.topBool
              // &&
              //     (tabuleiroNavAdjInimigo[coordRaiz.top.letra]
              //             [coordRaiz.top.numero] !=
              //         "x")
              ) {
            selectedCoord(coordRaiz.top.letra, coordRaiz.top.numero);
          } else if (coordRaiz.bottomBool
              // &&
              //     (tabuleiroNavAdjInimigo[coordRaiz.bottom.letra]
              //             [coordRaiz.bottom.numero] !=
              //         "x")
              ) {
            selectedCoord(coordRaiz.bottom.letra, coordRaiz.bottom.numero);
          }
        }
        if (selectedLetraIA < 5) {
          if (selectedNumeroIA < 5) {
            quadrantesIa[0]++;
          } else {
            quadrantesIa[1]++;
          }
        } else {
          if (selectedNumeroIA < 5) {
            quadrantesIa[2]++;
          } else {
            quadrantesIa[3]++;
          }
        }
      }
    });

    //_showButtons(tabuleiroInimigo, letra, numero);

    // while (quantAtaques > 0) {
    //   letra = Random(DateTime.now().microsecondsSinceEpoch).nextInt(10);
    //   numero = Random(DateTime.now().millisecondsSinceEpoch).nextInt(10);
    //   selectedLetra = letra;
    //   selectedNumero = numero;
    //   _showButtons(tabuleiroInimigo, quantAtaques);
    //   tabuleiroTirosInimigo[letra][numero] = "x";
    //   quantAtaques--;
    // }
  }

  selectedCoord(letra, numero) {
    setState(() {
      selectedLetraIA = letra;
      selectedNumeroIA = numero;

      coord = Coordenadas(selectedLetraIA, selectedNumeroIA);
    });
  }

  _showButtons(tabuleiro, letra, numero) {
    loadDataIA();
    return Container(
      // height: 150,
      child: Column(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {
                    if ((selectedLetraIA == null) &&
                        (selectedNumeroIA == null)) {
                      _ataqueIA();
                      _submit();
                    }
                  },
                  child: Text(
                    "ATIRAR",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: listDropNave,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                    value: selectedNave,
                    iconSize: 0,
                    elevation: 16,
                    hint: Text(
                      "RESULTADO",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    onChanged: (value) {
                      selectedNave = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            color: Colors.black,
            onPressed: () {
              if ((selectedLetraIA != null) && (selectedNumeroIA != null)) {
                _submit();
              }
            },
            child: Text(
              "OK",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  selectedDirecao() {
    if (naveAux.codigo == "h") {
      isHidroTwo = true;
    } else if (navesAtingidosCoordLetra[0] == navesAtingidosCoordLetra[1]) {
      isHorizontal = true;
    } else if (navesAtingidosCoordNumero[0] == navesAtingidosCoordNumero[1]) {
      isVertical = true;
    }
  }

  setNavAdj() {
    //RIGHT
    if ((selectedNumeroIA + 1) <= 9) {
      tabuleiroNavAdjInimigoAux[selectedLetraIA][selectedNumeroIA + 1] = "x";
    }
    //LEFT
    if ((selectedNumeroIA - 1) >= 0) {
      tabuleiroNavAdjInimigoAux[selectedLetraIA][selectedNumeroIA - 1] = "x";
    }
    //BOTTOM
    if ((selectedLetraIA + 1) <= 9) {
      tabuleiroNavAdjInimigoAux[selectedLetraIA + 1][selectedNumeroIA] = "x";
    }
    //TOP
    if ((selectedLetraIA - 1) >= 0) {
      tabuleiroNavAdjInimigoAux[selectedLetraIA - 1][selectedNumeroIA] = "x";
    }
    //TOP LEFT
    if (((selectedLetraIA - 1) >= 0) && ((selectedNumeroIA - 1) >= 0)) {
      tabuleiroNavAdjInimigoAux[selectedLetraIA - 1][selectedNumeroIA - 1] =
          "x";
    }
    //TOP RIGHT
    if (((selectedLetraIA - 1) >= 0) && ((selectedNumeroIA + 1) <= 9)) {
      tabuleiroNavAdjInimigoAux[selectedLetraIA - 1][selectedNumeroIA + 1] =
          "x";
    }
    //BOTTOM LEFT
    if (((selectedLetraIA + 1) <= 9) && ((selectedNumeroIA - 1) >= 0)) {
      tabuleiroNavAdjInimigoAux[selectedLetraIA + 1][selectedNumeroIA - 1] =
          "x";
    }
    //BOTTOM RIGHT
    if (((selectedLetraIA + 1) <= 9) && ((selectedNumeroIA + 1) <= 9)) {
      tabuleiroNavAdjInimigoAux[selectedLetraIA + 1][selectedNumeroIA + 1] =
          "x";
    }
  }

  String _getResultadoIA(tabuleiro) {
    if ((selectedLetraIA != null) && (selectedNumeroIA != null)) {
      if (tabuleiro[selectedLetraIA][selectedNumeroIA] != "") {
        String cod = tabuleiro[selectedLetraIA][selectedNumeroIA].toString();
        naveAux = _getNave(cod);

        checkBack = false;
        setNavAdj();

        navesAtingidos.add(cod);
        navesAtingidosCoordLetra.add(selectedLetraIA);
        navesAtingidosCoordNumero.add(selectedNumeroIA);

        if (navesAtingidos.length.toInt() > 1) {
          selectedDirecao();
        }

        selectedLetraIA = null;
        selectedNumeroIA = null;
        selectedNave = null;

        if (navesAtingidos.length.toInt() == naveAux.tam) {
          switch (naveAux.codigo) {
            case "s":
              submarinosIa--;
              break;
            case "d":
              destroyersIa--;
              break;
            case "h":
              hidroavioesIa--;
              break;
            case "c":
              cruzadoresIa--;
              break;
            case "p":
              portavioesIa--;
              break;
            default:
          }
          print("Tam TAm taM");

          for (int p = 0; p < 10; p++) {
            for (int q = 0; q < 10; q++) {
              tabuleiroNavAdjInimigo[p][q] = tabuleiroNavAdjInimigoAux[p][q];
            }
          }

          navesAtingidosCoordLetra.clear();
          navesAtingidosCoordNumero.clear();
          navesAtingidos.clear();
          navesDestruidos.add(1);
          return "Um ${naveAux.nome} foi destruído!";
        } else {
          return "Acertou um ${naveAux.nome}!";
        }
      } else {
        if (isHorizontal || isVertical) {
          checkBack = true;
        }
        selectedLetraIA = null;
        selectedNumeroIA = null;
        selectedNave = null;
        return "Tiro na água!";
      }
    } else {
      return "";
    }
  }
}
