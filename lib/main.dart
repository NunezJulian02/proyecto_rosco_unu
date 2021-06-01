import 'package:flutter/material.dart';

// {} Creando El juego Rosco (Pasapalabra)
import 'dart:html';

void main() {
  //realizando una instancia de clase
  var rosco = Rosco();
  //Llamando a un metodo
  var primeraDefinicion = rosco.obtenerPregunta();
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

class Rosco {
  //Creando una lista del Tipo Pregunta (Char, int, etc)
  List<Pregunta> roscoPreguntas = [];
  //Datos del Juego (Atributos)
  //Las variables son temporales
  //Static = Indica que la variable permanece en la memoria
  //const = indica que los valores no van a cambiar
  static List letras = const ["A", "B", "C", "D", "E", "F"];
  static List definiciones = const [
    "Tripulante de un cohete espacial ",
    "Animal asociado al mejor amigo del hombre",
    "Representante de un pais",
    "Animal terreste mas grande",
    "bebida representativa de Argentina",
    "Objeto utilizado para guardar lapices"
  ];
  static List respuestas = [
    "Astronauta",
    "Perro",
    "Presidente",
    "Elefante",
    "Mate",
    "Cartuchera"
  ];
  //Creando el Constructor para Cargar las preguntas con valores
  Rosco() {
    //El for recorre la primera coleccion de letras
    //el index toma los valores de las colecciones def. y respuestas
    for (var letra in letras) {
      var index = letras.indexOf(letra);
      //Se crea una instancia de pregunta, envia las letras cargadas
      //en los atributos y los almacena en la lista "roscoPreguntas"
      var roscoPregunta =
          Pregunta(letra, definiciones[index], respuestas[index]);
      roscoPreguntas.add(roscoPregunta);
    }
  }
  //Creando el Retorno del metodo
  Pregunta obtenerPregunta() {
    return roscoPreguntas[0];
  }

  //Metodo
  Pregunta pasapalabra() {
    return Pregunta("", "", "");
  }

  //Metodo
  String evaluarRespuesta(String letra, String respuesta) {
    //almacena la variable boolean de any
    //any busca variables iguales dentro de roscoPreguntas
    var esCorrecta = roscoPreguntas.any(
        (funcion) => funcion.letra == letra && funcion.respuesta == respuesta);

    if (esCorrecta == true) {
      return "letra $letra respuesta correcta";
    }

    return "Letra $letra respuesta incorrecta";
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
