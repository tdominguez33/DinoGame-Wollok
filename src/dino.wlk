import wollok.game.*
   
const color = "535353FF"
const velocidad = 50 			//Cada cuantos ms se mueven los elementos en pantalla
const movimiento = 5			//Cuantas celdas se mueven los elementos en pantalla
const thresholdColision = 7 	//Cantidad de celdas máxima al obstaculo para considerar una colisión
const distanciaMaxima = 50 		//Distancia máxima que se puede alejar un obstáculo del borde de la pantalla (Usado para randomizar)

object juego {

	var hiScore = 0
	var pausado = false

	method configurar(){
		game.cellSize(5) 	//Tamaño de las celdas
		game.width(120)		//Cantidad de celdas de ANCHO
		game.height(80)		//Cantidad de celdas de LARGO
		game.title("Dino Game - Modificado por Tomás Dominguez")
		game.addVisual(menuInicio)
		game.boardGround("src/assets/img/fondo.png")
		keyboard.s().onPressDo{
			self.configurarJuego()
			self.iniciar()
		}
		//Hace falta una función para poder cerrar la aplicación
		keyboard.e().onPressDo{
			
		}
	} 
	
	method configurarJuego(){
		game.clear()
		game.boardGround("src/assets/img/fondo.png")
		game.addVisual(suelo_0)
		game.addVisual(suelo_1)
		game.addVisual(cactus)
		game.addVisualCharacter(dino)
		game.addVisual(reloj)
		game.addVisual(maxScore)
		game.addVisual(otroDino)
		keyboard.space().onPressDo{self.jugar()}
		keyboard.enter().onPressDo{self.pausar()}
		
		//Implementar cuando se mantiene la tecla
		//keyboard.left().onPressDo{dino.moverIzquierda()}
		//keyboard.right().onPressDo{dino.moverDerecha()}
	}
	
	method iniciar(){
		self.iniciarMovimiento()
		suelo_0.iniciar()
		suelo_1.iniciar()
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		otroDino.iniciar()
	}
	
	method pausar(){
		if (not pausado && not dino.saltando()){
			self.detenerMovimiento()
			game.addVisual(pausa)
			pausado = true
		}
		else if (pausado){
			game.removeVisual(pausa)
			self.iniciarMovimiento()
			pausado = false
		}
	}
	
	method terminar(){
		game.addVisual(gameOver)
		self.detenerMovimiento()
		dino.morir()
		if (hiScore < reloj.tiempo()) {
			hiScore = reloj.tiempo()
		}
	}
	
	method iniciarMovimiento(){
		game.onTick(velocidad,"movimiento",{self.movimiento()})
		if (not dino.saltando()){
			game.onTick(velocidad,"dinoCorrer",{dino.correr()})
		}
		
	}
	
	method detenerMovimiento(){
		game.removeTickEvent("movimiento")
		if (not dino.saltando())
			game.removeTickEvent("dinoCorrer")
	}
	
	method movimiento(){
		cactus.mover()
		suelo_0.mover()
		suelo_1.mover()
		otroDino.mover()
		reloj.pasarTiempo()
		otroDino.correr()
		if (dino.posicion().distance(cactus.posicion()) < thresholdColision){
			cactus.chocar()
		}
		if (dino.posicion().distance(otroDino.posicion()) < thresholdColision){
			otroDino.chocar()
		}
	}
	
	method jugar(){
		if (dino.estaVivo() && not pausado) 
			dino.saltar()
		else if (not dino.estaVivo() && not pausado){
			game.removeVisual(gameOver)
			self.iniciar()
		}	
	}
	
	method hiScore(){
		return hiScore
	}
	
}

object menuInicio {
	method position() = game.origin().right(15).down(5)
	method image() = "src/assets/img/menuInicio.png"
}

object gameOver {
	method position() = game.center().left(30).down(30)
	method image() = "src/assets/img/gameOver.png"
}

object pausa {
	method position() = game.center().left(60).down(40)
	method image() = "src/assets/img/pausa.png"
}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method textColor() = color
	method position() = game.at(1, game.height()-10)
	
	method pasarTiempo() {
		tiempo = tiempo + 1
		if (tiempo % 100 == 0){
			const sfx100Puntos = game.sound("src/assets/sfx/marioCoin.mp3")
			sfx100Puntos.volume(0.7)
			sfx100Puntos.play()
		}
	}
	method iniciar(){
		tiempo = 0
	}
	
	method tiempo(){
		return tiempo
	}
}

object maxScore {
	method text() = "High Score: " + juego.hiScore().toString()
	method textColor() = color
	method position() = game.at(20, game.height()-10)
}

object cactus {
	
	const posicionInicial = game.at(game.width(), suelo_0.position().y())
	var position = posicionInicial
	var modificador = 1
	var n = 0

	method image() = "src/assets/img/cactus_" + n + ".png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
	}
	
	method mover(){
		position = position.left(movimiento)
		if (position.x() == -10){
			modificador = (new Range(start = 1, end = distanciaMaxima).anyOne()).div(10) * 10
			n = (new Range(start = 0, end = 5).anyOne()) % 5
			position = game.at(game.width()+modificador, suelo_0.position().y())
		}
		if (self.posicion().distance(otroDino.posicion()) < thresholdColision){
			position = position.right(10)
		}
	}
	
	method posicion(){
		return position
	}
	
	method chocar(){
		juego.terminar()
	}
}

object otroDino {
	
	const posicionInicial = game.at(game.width()+50, suelo_0.position().y())
	var position = posicionInicial
	var modificador = 50
	var paso = 0
	
	method image() = "src/assets/img/otroDino_" + paso + ".png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
	}
	
	method mover(){
		position = position.left(movimiento)
		if (position.x() == -10){
			modificador = (new Range(start = 1, end = distanciaMaxima).anyOne()).div(10) * 10
			position = game.at(game.width()+modificador, suelo_0.position().y())
		}
	}
	
	method correr(){
		if (paso == 0){
			paso = 1
		}
		else{
			paso = 0
		}
	}
	
	method chocar(){
		juego.terminar()
	}
	
	method posicion(){
		return position
	}
}

object suelo_0 {
	const posicionInicial = game.origin().up(1)
	var posicion = posicionInicial
	
	method position() = posicion
	
	method image() = "src/assets/img/suelo.png"
	
	method iniciar(){
		posicion = posicionInicial
	}
	
	method mover(){
		posicion = posicion.left(movimiento)
		if (posicion.x() == -120)
			posicion = game.origin().up(1).right(120)
	}
}

object suelo_1 {
	const posicionInicial = game.origin().up(1).right(120)
	var posicion = posicionInicial
	
	method position() = posicion
	
	method image() = "src/assets/img/suelo.png"
	
	method iniciar(){
		posicion = posicionInicial
	}
	
	method mover(){
		posicion = posicion.left(movimiento)
		if (posicion.x() == -120)
			posicion = posicionInicial
	}
}

object dino {
	var vivo = true
	var position = game.at(1,suelo_0.position().y())
	var paso = 0
	var saltando = false
	
	method image()= "src/assets/img/dino_" + paso + ".png"
	
	method position() = position
	
	method saltar(){
		if(position.y() == suelo_0.position().y()) {
			self.subir()
			game.removeTickEvent("dinoCorrer")
			saltando = true
			game.schedule(velocidad*5,{self.bajar()})
		}
	}
	
	method correr(){
		if (paso == 0){
			paso = 1
		}
		else{
			paso = 0
		}
	}
	
	method subir(){
		position = position.up(10)
	}
	
	method bajar(){
		position = position.down(10)
		game.onTick(velocidad,"dinoCorrer",{self.correr()})
		saltando = false
	}
	/*
	method moverIzquierda(){
		position = position.left(1)
	}
	
	method moverDerecha(){
		position = position.right(1)
	}
	*/
	method morir(){
		vivo = false
	}

	method iniciar() {
		vivo = true
		position = game.at(1,suelo_0.position().y())
	}
	
	method estaVivo() {
		return vivo
	}
	
	method posicion(){
		return position
	}
	
	method saltando(){
		return saltando
	}
}