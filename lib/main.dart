//import 'package:flutter/material.dart';

// {} Creando El juego Rosco (Pasapalabra)
import 'dart:html';
import 'dart:collection';

class Rosco implements Resultado {
  //Creando una lista del Tipo Pregunta (Char, int, etc)
  ListQueue<Pregunta> roscoPreguntas =
      ListQueue<Pregunta>(); //inicializando lista

  List<String> respondidas = [];
  List<String> pasadas = [];
  int incorrectas = 0;
  int correctas = 0;
  int numPreguntas = 0;

  //Creando el Constructor para Cargar las preguntas con valores
  Rosco() {
    roscoPreguntas.addAll(RoscoApi().obtenerRoscos());
    numPreguntas = roscoPreguntas.length;
  }
  //Creando el Retorno del metodo
  Pregunta obtenerPregunta(bool inicial) {
    if (inicial) return roscoPreguntas.first;

    var siguientePregunta = roscoPreguntas.firstWhere(
        (rosco) =>
            !respondidas.any((x) => x == rosco.letra) &&
            !pasadas.any((x) => x == rosco.letra),
        orElse: () => null);

    if (siguientePregunta == null) {
      if (_puedoResetearRosco()) {
        pasadas = [];
        return obtenerPregunta(false);
      } else {
        return roscoPreguntas.last;
      }
    }
    return siguientePregunta;
  }

  //Metodo
  Pregunta pasapalabra(String letraActual) {
    var siguientePregunta = roscoPreguntas.firstWhere(
        (rosco) =>
            !(rosco.letra == letraActual) &&
            !pasadas.any((x) => x == rosco.letra) &&
            !respondidas.any((x) => x == rosco.letra),
        orElse: () => null);
    if (siguientePregunta == null) {
      if (_puedoResetearRosco()) {
        pasadas = [];
        return pasapalabra("");
      } else {
        return roscoPreguntas.last;
      }
    }

    pasadas.add(letraActual);
    return siguientePregunta;
  }

  //Metodo
  String evaluarRespuesta(String letra, String respuesta) {
    //almacena la variable boolean de any
    //any busca variables iguales dentro de roscoPreguntas
    var pregunta = roscoPreguntas.firstWhere((rosco) => rosco.letra == letra);

    respondidas.add(pregunta.letra);

    if (pregunta.respuesta == respuesta) {
      correctas++;
      return "Letra $letra es correcta";
    }
    incorrectas++;
    return "Letra $letra respuesta incorrecta";
  }

  bool _puedoResetearRosco() {
    return roscoPreguntas
        .any((rosco) => !respondidas.any((x) => x == rosco.letra));
  }
}

class Pregunta {
  //define el tipo de variable
  String letra;
  String definicion;
  String respuesta;
  //Asigna a las variables el valor entrante
  Pregunta(
    this.letra,
    this.definicion,
    this.respuesta,
  );
}

class Db {
  //Datos del Juego (Atributos)
  //Las variables son temporales
  //Static = Indica que la variable permanece en la memoria
  //const = indica que los valores no van a cambiar
  static List letras = const ["A", "B", "C", "D", "E", "F"];
  static List definiciones = const [
    "Persona que tripula una Astronave o que estaก entrenada para este Trabajo",
    "Especie de Talega o Saco de Tela y otro material que sirve para llevar o guardar algo",
    "Aparato destinado a registrar imรกgenes animadas para el cine o la telivision",
    "Obra literaria escrita para ser representada",
    "Que se prolonga muchisimo o excesivamente",
    "Laboratorio y despacho del farmaceutico"
  ];
  static List respuestas = [
    "Astronauta",
    "Bolsa",
    "Camara",
    "Drama",
    "Eterno",
    "Farmacia"
  ];
}

class RoscoApi {
  List<Pregunta> roscoPreguntas = [];

  List<Pregunta> obtenerRoscos() {
    //El for recorre la primera coleccion de letras
    //el index toma los valores de las colecciones def. y respuestas
    for (var letra in Db.letras) {
      var index = Db.letras.indexOf(letra);
      //Se crea una instancia de pregunta, envia las letras cargadas
      //en los atributos y los almacena en la lista "roscoPreguntas"
      var roscoPregunta =
          Pregunta(letra, Db.definiciones[index], Db.respuestas[index]);
      roscoPreguntas.add(roscoPregunta);
      //Cuando un atributo es "static" no necesita ser instanciado.
    }

    return roscoPreguntas;
  }
}

abstract class Resultado {
  int incorrectas;
  int correctas;
  int numPreguntas;
}

class RoscoEstado {
  bool continuar = true;
  bool continuarRosco(Resultado resultado) {
    _evaluarRosco(resultado.correctas == resultado.numPreguntas,
        "Felicidades Ganaste el Rosco");
    _evaluarRosco(resultado.incorrectas == resultado.numPreguntas,
        "Se acabo el Rosco :(");
    _evaluarRosco(
        resultado.correctas + resultado.incorrectas == resultado.numPreguntas,
        "Se acabo el Rosco :(");
    return continuar;
  }

  void _evaluarRosco(bool condicion, mensaje) {
    if (condicion) {
      continuar = false;
      print(mensaje);
    }
  }
}

void main() {
  //Nos comunica con el HTML y demas clases
  //realizando una instancia de clase
  var rosco = Rosco();
  //Llamando a un metodo
  var primeraDefinicion = rosco.obtenerPregunta(true);
  //Conectando primeradefinicion con el Label Html
  //Con solo el ID del label html se puede modificar su valor
  querySelector("#pregunta").text = primeraDefinicion.definicion;
  querySelector("#letra").text = primeraDefinicion.letra;

  //Captura el evento de una funcion
  querySelector("#btnEnviar").onClick.listen((event) {
    //Vamos a tomar los valores de respuesta y letra para almacenarlos
    //V convierte el queryS. a un input (el de html) para tomar su valor
    var respuesta = (querySelector("#textRespuesta") as InputElement).value;
    //Ya tomamos el valor de respuesta, ahora va el de letra
    var letra = querySelector("#letra").text;

    //LLamando al metodo evaluarrespuesta
    String mensaje = rosco.evaluarRespuesta(letra, respuesta);

    var roscoEstado = RoscoEstado();
    if (roscoEstado.continuarRosco(rosco)) {
      var nuevaPregunta = rosco.obtenerPregunta(false);
      actualizarUI(nuevaPregunta);
      print(mensaje);
    } else {
      desabilitar();
    }
  });

  querySelector("#btnPasapalabra").onClick.listen((event) {
    var roscoEstado = RoscoEstado();
    if (roscoEstado.continuarRosco(rosco)) {
      var nuevaPregunta = rosco.pasapalabra(querySelector("#letra").text);
      actualizarUI(nuevaPregunta);
    } else {
      desabilitar();
    }
  });
} //Metodo

void actualizarUI(Pregunta pregunta) {
  querySelector("#letra").text = pregunta.letra;
  querySelector("#pregunta").text = pregunta.definicion;
  querySelector("#textrespuesta").text = " ";
}

void desabilitar() {
  (querySelector("#btnEnviar") as ButtonElement).disabled = true;
  (querySelector("#btnPasapalabra") as ButtonElement).disabled = true;
}
