import 'package:flutter/material.dart';

class Remedio {
  int? id;
  String nome;
  String tipo;
  String frequencia;
  String recorrencia;
  String duracao;
  int corValue;
  int iconeCodePoint;
  String iconeFontFamily; 
  String mensagem;
  int dosesDiarias; 

  Remedio({
    this.id,
    required this.nome,
    required this.tipo,
    required this.frequencia,
    required this.recorrencia,
    required this.duracao,
    required this.corValue,
    required this.iconeCodePoint,
    required this.iconeFontFamily,
    this.mensagem = "Não esqueça do seu remédio!",
    this.dosesDiarias = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'frequencia': frequencia,
      'recorrencia': recorrencia,
      'duracao': duracao,
      'corValue': corValue,
      'iconeCodePoint': iconeCodePoint,
      'iconeFontFamily': iconeFontFamily,
      'mensagem': mensagem,
      'dosesDiarias': dosesDiarias,
    };
  }

  factory Remedio.fromMap(Map<String, dynamic> map) {
    return Remedio(
      id: map['id'],
      nome: map['nome'],
      tipo: map['tipo'],
      frequencia: map['frequencia'],
      recorrencia: map['recorrencia'],
      duracao: map['duracao'],
      corValue: map['corValue'],
      iconeCodePoint: map['iconeCodePoint'],
      iconeFontFamily: map['iconeFontFamily'],
      mensagem: map['mensagem'] ?? "Não esqueça do seu remédio!",
      dosesDiarias: map['dosesDiarias'] ?? 1,
    );
  }

  Color get cor => Color(corValue);
  IconData get icone => IconData(iconeCodePoint, fontFamily: iconeFontFamily);
}