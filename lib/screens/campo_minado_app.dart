import 'package:campo_mindado/components/tabuleiro_widget.dart';
import 'package:campo_mindado/models/tabuleiro.dart';
import 'package:flutter/material.dart';
import '../components/resultado_widget.dart';
import '../models/campo.dart';
import '../models/explosao_exception.dart';

class CampoMinadoApp extends StatefulWidget {
  @override
  _CampoMinadoAppState createState() => _CampoMinadoAppState();
}

class _CampoMinadoAppState extends State<CampoMinadoApp> {
  bool _venceu;
  Tabuleiro _tabuleiro = Tabuleiro(
    linhas: 15,
    colunas: 15,
    qtdeBombas: 30,
  );

  _reiniciar() {
    setState(() {
      _venceu = null;
      _tabuleiro.reiniciar();
    });
  }

  _abrir(Campo campo) {
    setState(() {
      if (_venceu != null) {
        return;
      }
      try {
        campo.abrir();
        if (_tabuleiro.resolvido) {
          _venceu = true;
        }
      } on ExplosaoException {
        _venceu = false;
        _tabuleiro.revelarBombas();
      }
    });
  }

  void _alternarMarcacao(Campo campo) {
    if (_venceu != null) {
      return;
    }

    setState(() {
      campo.alternarMarcacao();
      if (_tabuleiro.resolvido) {
        _venceu = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: ResultadoWidget(
          venceu: _venceu,
          onReiniciar: _reiniciar,
        ),
        body: Container(
          child: TabuleiroWidget(
            tabuleiro: _tabuleiro,
            onAbrir: _abrir,
            onAlternarMarcacao: _alternarMarcacao,
          ),
        ),
      ),
    );
  }
}
