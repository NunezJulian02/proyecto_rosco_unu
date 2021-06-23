//import 'package:flutter/material.dart';

// {} Creando El juego Rosco (Pasapalabra)
import 'dart:html';
import 'dart:collection';

class Rosco {
  //Creando una lista del Tipo Pregunta (Char, int, etc)
  ListQueue<Pregunta> roscoPreguntas =
      ListQueue<Pregunta>(); //inicializando lista
  //Creando el Constructor para Cargar las preguntas con valores
  Rosco() {
    roscoPreguntas.addAll(RoscoApi().obtenerRoscos());
  }
  //Creando el Retorno del metodo
  Pregunta obtenerPregunta(bool inicial) {
    if (inicial) return roscoPreguntas.first;
    return null;
  }

  //Metodo
  Pregunta pasapalabra() {
    return Pregunta("", "", "");
  }

  //Metodo
  String evaluarRespuesta(String letra, String respuesta) {
    //almacena la variable boolean de any
    //any busca variables iguales dentro de roscoPreguntas
    var esCorrecta = roscoPreguntas
        .any((rosco) => rosco.letra == letra && rosco.respuesta == respuesta);

    return esCorrecta
        ? "Letra $letra respuesta correcta"
        : "Letra $letra respuesta incorrecta"; //Otra forma de IF
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
    print(mensaje);
  });
} //Metodo
