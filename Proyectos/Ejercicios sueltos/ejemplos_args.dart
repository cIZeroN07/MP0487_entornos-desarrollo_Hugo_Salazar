void main(List<String> args) {
  String message = "Ada Lovelace";
  print(message);

  print("Argumentos recibidos: $args");
  print("¿Cuántos argumentos me dieron? ${args.length}");

  if (args.length > 0) {
    print("El primero es: ${args[0]}");
  } else {
    print("No me diste ningún argumento");
  }
}
