
# Juego *Dino* modificado

## Gameplay:

<p align="center">
  <img src="https://raw.githubusercontent.com/pdep-utn-frd/2022-tpobj1-tdominguez33/master/src/assets/img/readme/readme_gif.gif" alt="Gameplay"/>
</p>

## Como Jugar

#### <img align="center" src="https://raw.githubusercontent.com/pdep-utn-frd/2022-tpobj1-tdominguez33/master/src/assets/img/readme/s.png" alt="S" width="50"/> - Comenzar
#### <img src="https://raw.githubusercontent.com/pdep-utn-frd/2022-tpobj1-tdominguez33/master/src/assets/img/readme/espacio.png" alt="Espacio" width="100"/> - Saltar
#### <img align="center" src="https://raw.githubusercontent.com/pdep-utn-frd/2022-tpobj1-tdominguez33/master/src/assets/img/readme/enter.png" alt="Enter" width="50"/> - Pausar
#### <img align="center" src="https://raw.githubusercontent.com/pdep-utn-frd/2022-tpobj1-tdominguez33/master/src/assets/img/readme/abajo.png" alt="Abajo" width="50"/> - Bajar

## Lista de Modificaciones:

 - Se añadió un nuevo obstaculo (otro Dino que va al revés).
 - Ahora la velocidad del juego aumenta cada 20 puntos.
 - Se agregó un multiplicador de 2X duplicando la cantidad de puntos que se obtienen por 5 segundos.
 - Se agregó una pantalla de inicio cada vez que se abre el juego.
 - Se agregó una pantalla de pausa cada vez que se presiona la tecla Enter.
 - Se cambió la pantalla de muerte.
 - Se cambiaron las imagenes del suelo y fondo.
 - Se agregaron varios diseños de cactus que cambian aleatoriamente.
 - Se agregó un efecto de sonido cada vez que se consigue un múltiplo de 100 puntos.
 - Se cambió el color de la fuente del texto para combinar con la estética.
 - Se cambió el tamaño de las celdas de 50px a 5px cada una para movimientos más fluidos.
 - Ahora tanto nuestro dino como el dino obstaculo tienen una pequeña animación para correr.
 - Se añadió un contador de Hi-Score (Puntaje Máximo).
 - Se realizaron optimizaciones al codigo (Se redujeron los game.onTick() a solo dos).
 - Se randomizaron las posiciones del cactus y del dino una vez que desaparecen de la pantalla.
 - Se cambió el sistema de colisiones, en lugar de usar onCollideDo() se utilizan un if por obstaculo para chequear las posiciones y así poder usar un rango en lugar de un punto especifico.
## Modificado por Tomás Dominguez