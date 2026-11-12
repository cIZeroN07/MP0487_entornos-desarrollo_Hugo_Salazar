# Documentación de correcciones — MP0487 RA1/RA2 Intro Dart

Este documento explica, uno por uno, los 21 errores reportados como Issues en GitHub y qué se cambió para solucionarlos. Están agrupados por archivo.

---

## 🍕 samples/05_pizzeria.dart (+ config.dart → PizzaConfig)

### #1 — Nombre de la pizzería incorrecto
**Problema:** el mensaje de bienvenida decía "Slice & Dice Pizzeria" en vez del nombre pedido.
**Archivo:** `config.dart`, clase `PizzaConfig`, campo `welcomeMsg`.
**Arreglo:** se cambió el texto a `"=== Welcome to the Mario Bros Pizzeria Terminal ==="`.

### #2 — Falta la pizza Vegetariana en el menú
**Problema:** la pizza "Vegetarian" sí estaba guardada en la lista `menuPizzas`, pero el bucle que imprime el menú no llegaba hasta ella.
```dart
for (int i = 0; i < menuPizzas.length-1; i++) {   // ❌ se salta el último elemento
```
Con 4 pizzas, `menuPizzas.length` es 4, pero `-1` hace que el bucle solo recorra `i = 0,1,2` (3 vueltas), dejando fuera el índice 3 (Vegetarian).
**Arreglo:** quitar el `-1`:
```dart
for (int i = 0; i < menuPizzas.length; i++) {
```
Esto es un error clásico llamado **"off-by-one"** (fuera por uno): el bucle se queda corto por una vuelta.

### #3 — Precio final incorrecto en pizzas Large
**Problema:** al elegir tamaño Large, el precio base de la pizza se **borraba** en vez de sumarle el extra.
```dart
} else if (sizeInput == "L") {
  targetSize = PizzaConfig.largeSize;
  calculationPrice = 4.00;   // ❌ sobrescribe el precio, no lo suma
}
```
Compáralo con el caso Medium, que sí estaba bien: `calculationPrice += 2.00;`.
**Arreglo:** cambiar `=` por `+=`:
```dart
calculationPrice += 4.00;
```
`=` significa "asigna este valor" (reemplaza), `+=` significa "suma este valor a lo que ya había". Una Pepperoni Large pasó de costar `$4.00` a costar `$14.99` (10.99 base + 4.00 del tamaño), que es lo correcto.

### #4 — Mensaje incorrecto con el carrito vacío
**Problema:** al ver el carrito vacío, el programa mostraba el mensaje de agradecimiento final (`thankYouMsg`, "Thank you for your business!") en vez de avisar que está vacío.
```dart
if (cartPizzas.isEmpty) {
  print(PizzaConfig.thankYouMsg);   // ❌ mensaje equivocado
}
```
**Arreglo:** usar el mensaje correcto que ya existía en la configuración (`emptyCartMsg`) pero nunca se usaba:
```dart
print(PizzaConfig.emptyCartMsg);   // "Your cart is completely empty."
```

### #5 — Añadir pizza Carbonara al menú
**Petición:** agregar una nueva pizza, Carbonara, a $10.99.
**Arreglo:** se añadió a las dos listas paralelas en `05_pizzeria.dart`:
```dart
List<String> menuPizzas = ["Margherita", "Pepperoni", "BBQ Chicken", "Vegetarian", "Carbonara"];
List<double> basePrices = [8.99, 10.99, 11.99, 9.99, 10.99];
```
Como el menú y los precios usan **listas paralelas** (la pizza en la posición `i` de una lista corresponde al precio en la posición `i` de la otra), bastó con añadir un elemento a cada lista, en la misma posición.

### #6 — "Cancel Order and Exit" no cierra el programa
**Problema:**
```dart
case "5":
  print(PizzaConfig.cancelMsg);
  ordering == false;   // ❌ esto es una COMPARACIÓN, no una asignación
  break;
```
`==` compara dos valores y da `true`/`false`, pero no guarda nada. El valor resultante se descarta y `ordering` nunca cambia, así que el `while (ordering)` nunca termina.
**Arreglo:** un solo signo `=` (asignación):
```dart
ordering = false;
```

---

## 📦 samples/01_shipment.dart (+ config.dart → ShipmentConfig)

### #7 — "Track a Shipment" no volvía a preguntar si el ID no existía
**Problema:** si el ID no se encontraba, el programa avisaba una vez y volvía directo al menú principal.
**Arreglo:** se envolvió la lógica de "preguntar ID + buscar" dentro de un `while (!found) { ... }`, con `break` para cancelar (si el usuario deja el campo vacío) o para salir cuando se encuentra el envío. Mientras no se encuentre, el bucle se repite solo y vuelve a preguntar.

### #8 — La opción 1 ("View All Shipments") daba "invalid menu option"
**Problema:**
```dart
case "l":   // ❌ la letra "ele" minúscula, no el número "1"
```
El usuario escribe `1` (el número uno) en el teclado, pero el `case` comparaba contra la letra `"l"` — nunca coinciden, así que siempre caía en el `default` ("opción inválida").
**Arreglo:** `case "1":` (el número, no la letra).

### #9 — Actualizar a "Delivered" mostraba éxito pero guardaba el estado equivocado
**Problema:**
```dart
} else if (statusChoice == "D") {
  statuses[i] = ShipmentConfig.outForDeliveryStatus;   // ❌ repite el estado de la opción C
}
```
La opción **D** (Delivered) estaba guardando el mismo valor que la opción **C** (Out for Delivery) — probablemente un copia-pega sin terminar de ajustar.
**Arreglo:**
```dart
statuses[i] = ShipmentConfig.deliveredStatus;
```

### #10 — Faltaba mensaje de error al actualizar un ID inexistente
**Problema:** en la opción "Update Shipment Status", si el ID no existía, el aviso estaba comentado y no se mostraba nada:
```dart
if (!found) {
  //print(ShipmentConfig.idNotFoundMsg);   // ❌ comentado, no se ejecuta
}
```
**Arreglo:** se quitó el `//` para activar la línea:
```dart
print(ShipmentConfig.idNotFoundMsg);
```

### #11 — Añadir 2 envíos de ejemplo más
**Petición:** agregar Paris (Processing, 8.2 kg) y Sydney (Delivered, 14.5 kg) a los datos iniciales.
**Arreglo:** se añadió un elemento a cada una de las 4 listas paralelas (`shipmentIds`, `destinations`, `statuses`, `weights`), con IDs nuevos `104` y `105`.

### #12 — Error de texto en la opción 5 del menú
**Problema:** decía `"5. Calculate Total Shipping Height"` (altura) en vez de `"Weight"` (peso).
**Arreglo:** corregido el texto en `config.dart`.

### #13 — Peso incorrecto al añadir un nuevo envío
**Problema:**
```dart
weights.add(0.0);   // ❌ ignora lo que escribió el usuario, siempre guarda 0.0
```
El programa sí leía el peso que escribía el usuario (`newWeight`), pero luego no lo usaba — guardaba un `0.0` fijo.
**Arreglo:**
```dart
weights.add(newWeight);
```

### #14 — El peso total se calculaba mal
**Problema:**
```dart
double totalWeight = 0.0;
for (double w in weights) {
  totalWeight *= w;   // ❌ multiplica en vez de sumar
}
```
Como `totalWeight` empieza en `0.0`, multiplicar por `0.0` siempre da `0.0` — el resultado nunca podía ser correcto.
**Arreglo:** cambiar `*=` por `+=` (sumar cada peso al total, en vez de multiplicar):
```dart
totalWeight += w;
```

### #15 — Añadir opción para mostrar el envío más pesado
**Petición:** nueva opción de menú, justo después de "Calculate Total Weight", que muestre el envío con más peso.
**Arreglo:** se añadió como nueva **opción 6**, y la antigua opción 6 ("Exit") pasó a ser la **opción 7** (se actualizaron los textos del menú y el rango de opciones válidas, de 1-6 a 1-7, en `config.dart`). La lógica nueva recorre la lista de pesos buscando el índice del valor más alto (el mismo patrón que ya usabais para buscar el mínimo en otros ejercicios, pero con `>` en vez de `<`), y luego imprime los datos de ese envío usando su índice en las 4 listas paralelas.

---

## 🚌 samples/02_bus_tracker.dart (+ config.dart → BusTrackerConfig)

### #16 — Typo en los datos: "Line 7B" debería ser "Line 78"
**Arreglo:** corregido directamente en la lista `busNumbers`.

### #17 — La opción 1 ("View All Active Buses") colgaba/crasheaba el programa
**Problema:**
```dart
for (int i = 0; i <= busNumbers.length; i++) {   // ❌ "<=" en vez de "<"
```
Con 5 buses, los índices válidos son `0` a `4`. Con `<=`, el bucle también intenta `i = 5`, que no existe en la lista — esto provoca un error de "índice fuera de rango" y el programa se detiene de golpe.
**Arreglo:** `<` en vez de `<=` (otro caso de off-by-one, como el de la pizza Vegetariana, pero al revés: aquí el bucle se pasaba de largo en vez de quedarse corto).

### #18 — "Search Buses by Stop Name" no encontraba resultados
**Problema:**
```dart
if (stopNames[i].toUpperCase() == searchStop.toLowerCase()) {
```
Se compara un texto convertido a **mayúsculas** contra otro convertido a **minúsculas** — nunca van a coincidir (salvo casos muy raros), así que la búsqueda nunca encontraba nada.
**Arreglo:** poner el mismo "casing" en ambos lados:
```dart
if (stopNames[i].toUpperCase() == searchStop.toUpperCase()) {
```

### #19 — "Check Next Closest Bus" no funcionaba
**Problema:**
```dart
if (!arrivalTimes.isEmpty) {   // ❌ lógica invertida
  print(BusTrackerConfig.noBusesGridMsg);   // "no hay buses"... ¡cuando SÍ hay!
} else {
  // ... aquí estaba la búsqueda real, pero solo se ejecutaba cuando la lista SÍ estaba vacía
}
```
El `!` (negación) invertía la condición: decía "no hay buses" precisamente cuando sí los había, y solo intentaba buscar el bus más cercano cuando la lista estaba vacía (lo cual además habría provocado un error, por acceder a una lista vacía).
**Arreglo:** quitar el `!`:
```dart
if (arrivalTimes.isEmpty) {
```

### #20 — La opción 6 ("Exit") entraba en bucle infinito
**Problema:**
```dart
case "6":
  print(BusTrackerConfig.exitMsg);
  active = true;   // ❌ debería ser "false" para terminar el bucle
```
El bucle principal es `while (active)`. Poner `active = true` (en vez de `false`) hace que la condición siga siendo verdadera para siempre — el programa nunca sale del bucle, por mucho que elijas "Exit".
**Arreglo:** `active = false;` (ahora en la opción **7**, ver siguiente punto).

### #21 — Añadir opción para calcular el tiempo medio de llegada de todos los buses
**Petición:** nueva opción, después de "Check Next Closest Bus", que calcule la media de los tiempos de llegada.
**Arreglo:** igual que en el caso del envío más pesado (#15), se añadió como nueva **opción 6**, y "Exit" pasó a ser la **opción 7**. La lógica nueva suma todos los tiempos de llegada con un bucle `for` y divide por la cantidad de buses (`total / arrivalTimes.length`) para obtener la media.

---

## Conceptos que se repiten en varios de estos errores

Para que te sirva de chuleta rápida, estos son los **patrones de bug** que aparecieron una y otra vez en los 21 casos:

| Patrón | Ejemplos | Qué mirar |
|---|---|---|
| **`=` vs `==`** | #6 | `=` asigna, `==` compara. Si usas `==` donde debía ir `=`, el valor nunca cambia. |
| **`=` vs `+=`** | #3 | `=` reemplaza el valor entero, `+=` lo suma al que ya había. |
| **`*=` vs `+=`** | #14 | Si el acumulador empieza en 0 y multiplicas, el resultado siempre será 0. |
| **Off-by-one (`<` vs `<=`, o `.length` vs `.length - 1`)** | #2, #17 | Compara cuántos elementos tiene la lista contra hasta dónde llega el bucle. |
| **Nombre de variable/case equivocado** | #8 | `"l"` (letra) en vez de `"1"` (número) — se ven parecidos pero no son lo mismo para el programa. |
| **Bloques copiados sin terminar de ajustar** | #9 | Comparar casos similares (A, B, C, D) entre sí para ver si alguno "quedó igual" al de al lado por error. |
| **Lógica invertida con `!`** | #19 | El `!` invierte una condición; revisa si el mensaje que imprime tiene sentido con la condición real. |
| **Código comentado que no debería estarlo** | #10 | Una línea con `//` delante no se ejecuta nunca, aunque esté "ahí". |
| **Valor leído pero nunca usado** | #13 | Se lee algo del usuario (`newWeight`) pero luego se usa un valor fijo en su lugar. |
