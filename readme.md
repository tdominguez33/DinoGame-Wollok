# Juego *Dino* modificado


**Lista de Modificaciones:**

 - Se añadió un nuevo obstaculo (otro Dino que va al revés).
 - Se cambiaron las imagenes del suelo y fondo.
 - Se agregó un efecto de sonido al conseguir 100 puntos.
 - Se cambió el color de la fuente del texto para combinar con la estética.
 - Se cambió el tamaño de las celdas de 50px a 5px cada una para movimientos más fluidos.
 - Ahora tanto nuestro dino como el dino obstaculo tienen una pequeña animación para correr.
 - Se añadió un contador de Hi-Score (Puntaje Máximo).
 - Se realizaron optimizaciones al codigo (Se redujeron los game.onTick() a solo dos).
 - Añadida nueva pantalla de muerte.
 - Se randomizaron las posiciones del cactus y del dino una vez que desaparecen de la pantalla.
 - Se cambió el sistema de colisiones, en lugar de usar onCollideDo() se utilizan un if por obstaculo para chequear las posiciones y así poder usar un rango en lugar de un punto especifico.
## Modificado por Tomás Dominguez
