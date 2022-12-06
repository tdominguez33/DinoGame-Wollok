import wollok.game.*
   
const color = "535353FF"
const velocidad = 50 			//Cada cuantos ms se mueven los elementos en pantalla
const movimiento = 5			//Cuantas celdas se mueven los elementos en pantalla
const thresholdColision = 7 	//Cantidad de celdas máxima al obstaculo para considerar una colisión
const distanciaMaxima = 50 		//Distancia máxima que se puede alejar un obstáculo del borde de la pantalla (Usado para randomizar)

object juego {
	var hiScore = 0
	var pausado = false
	var terminado = false
	var property velocidadMovimiento = velocidad

	method configurarVentana(){
		game.cellSize(5) 	//Tamaño de las celdas
		game.width(120)		//Cantidad de celdas de ANCHO
		game.height(80)		//Cantidad de celdas de ALTO
		game.title("DinoRun - Creado por Tomás Dominguez")
		game.addVisual(menuInicio)
		game.boardGround("src/assets/img/fondo.png")
		keyboard.s().onPressDo{
			self.configurarJuego()
			self.iniciar()
		}
		keyboard.e().onPressDo{
			game.stop()
		}
	} 
	
	method iniciar(){
		self.iniciarMovimiento()
		suelo_0.iniciar()
		suelo_1.iniciar()
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		otroDino.iniciar()
		multiplicador2X.iniciar()
	}
	
	method iniciarMovimiento(){
		game.onTick(velocidadMovimiento,"movimiento",{self.movimiento()})
		if (not dino.saltando()){
			game.onTick(velocidad,"dinoCorrer",{dino.correr()})
		}	
	}
	
	method configurarJuego(){
		velocidadMovimiento = velocidad
		game.clear()
		game.boardGround("src/assets/img/fondo.png")
		game.addVisual(suelo_0)
		game.addVisual(suelo_1)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(maxScore)
		game.addVisual(otroDino)
		keyboard.space().onPressDo{self.jugar()}
		keyboard.down().onPressDo{dino.bajar()}
		keyboard.enter().onPressDo{self.pausar()}
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
		self.reiniciarVelocidad()
		dino.morir()
		terminado = true
		if (hiScore < reloj.puntaje()) {
			hiScore = reloj.puntaje()
		}
		reloj.reiniciarPuntos()
		if (multiplicador2X.activo()){
			multiplicador2X.desactivar()
		}
	}
	
	method aumentarVelocidad(aumento){
		velocidadMovimiento = (velocidadMovimiento - aumento).max(20)
		game.removeTickEvent("movimiento")
		game.onTick(velocidadMovimiento,"movimiento",{self.movimiento()})
	}
	
	method reiniciarVelocidad(){
		velocidadMovimiento = velocidad
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
		multiplicador2X.mover()
		
		if (not terminado){
			if (dino.posicion().distance(cactus.position()) < thresholdColision){
				self.terminar()
			}
			if (dino.posicion().distance(otroDino.posicion()) < thresholdColision){
				self.terminar()
			}
			if (dino.posicion().distance(multiplicador2X.posicion()) < thresholdColision){
				multiplicador2X.activar()
			}
		}
		
	}
	
	method jugar(){
		if (dino.vivo() && not pausado) 
			dino.saltar()
		else if (not dino.vivo() && not pausado){
			game.removeVisual(gameOver)
			self.iniciar()
			terminado = false
		}	
	}
	
	method hiScore(){
		return hiScore
	}
	
	method velocidadMovimiento(){
		return velocidadMovimiento
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

object maxScore {
	method text() = "High Score: " + juego.hiScore().toString()
	method textColor() = color
	method position() = game.at(30, game.height()-10)
}

object reloj {
	
	var property tiempo = 0
	var property puntaje = 0
	var property multiplicador = 1
	
	method text() = puntaje.toString()
	method textColor() = color
	method position() = game.at(1, game.height()-10)
	
	method iniciar(){
		tiempo = 0
	}
	
	method reiniciarPuntos(){
		multiplicador = 1
		puntaje = 0
	}
	
	method pasarTiempo() {
		tiempo += 1
		puntaje += (multiplicador * 1)
		if (tiempo % 20 == 0 and juego.velocidadMovimiento() != 20){
			juego.aumentarVelocidad(1)
		}
		
		if (puntaje % 100 == 0){
			const sfx100Puntos = game.sound("src/assets/sfx/marioCoin.mp3")
			sfx100Puntos.volume(0.7)
			sfx100Puntos.play()
		}
		
		if (tiempo % (50.randomUpTo(100).div(1)) == 0 && not multiplicador2X.enPantalla() && not multiplicador2X.activo()){
			multiplicador2X.aparecer()
		}
	}
}

object cactus {
	
	const posicionInicial = game.at(game.width(), suelo_0.position().y())
	var property position = posicionInicial
	var modificador = 1
	var n = "0"

	method image() = "src/assets/img/cactus_" + n + ".png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
	}
	
	method mover(){
		position = position.left(movimiento)
		if (position.x() == -10){
			modificador = (new Range(start = 1, end = distanciaMaxima).anyOne()).div(10) * 10
			position = game.at(game.width()+modificador, suelo_0.position().y())
			n = ((0.randomUpTo(5)).div(1)).toString()
		}
		if (position.distance(otroDino.posicion()) < thresholdColision+15){
			position = position.right(15)
		}
	}
}

object otroDino {
	
	const posicionInicial = game.at(game.width()+50, suelo_0.position().y())
	var position = posicionInicial
	var modificador = 50
	var paso = "0"
	
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
		if (paso == "0"){
			paso = "1"
		}
		else{
			paso = "0"
		}
	}
	
	method posicion(){
		return position
	}
}

object multiplicador2X {
	const posicionInicial = game.at(game.width()+10, 10)
	var property posicion = posicionInicial
	var property enPantalla = false
	var property activo = false
	
	method image() = "src/assets/img/2X.png"
	method position() = posicion
	
	method iniciar(){
		posicion = posicionInicial
	}
	
	method mover(){
		if (self.enPantalla()){
			posicion = posicion.left(movimiento)
		}
		if (posicion.x() == -10){
			posicion = posicionInicial
			self.desaparecer()
		}
	}
	
	method aparecer(){
		posicion = posicionInicial
		game.addVisual(self)
		enPantalla = true
	}
	
	method desaparecer(){
		if (self.enPantalla()){
			game.removeVisual(self)
			posicion = posicionInicial
			enPantalla = false
		}
	}
	
	method activar(){
		activo = true
		reloj.multiplicador(2)
		self.desaparecer()
		game.addVisual(multiplicador2XBanner)
		game.schedule(5000, {self.desactivar()})
	}
	
	method desactivar(){
		if (activo){
			activo = false
			reloj.multiplicador(1)
			game.removeVisual(multiplicador2XBanner)
		}
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
	var property vivo = true
	var property posicion = game.at(1,suelo_0.position().y())
	var property saltando = false
	var paso = 0
	
	method image()= "src/assets/img/dino_" + paso.toString() + ".png"
	
	method position() = posicion
	
	method saltar(){
		if(posicion.y() == suelo_0.position().y()) {
			self.subir()
			game.removeTickEvent("dinoCorrer")
			saltando = true
			game.schedule(velocidad*5,{self.bajar()}) //Velocidad*5 = 250ms
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
		posicion = posicion.up(10)
	}
	
	method bajar(){
		if (self.saltando()){
			posicion = posicion.down(10)
			game.onTick(velocidad,"dinoCorrer",{self.correr()})
			saltando = false
		}
	}
	
	method morir(){
		vivo = false
	}

	method iniciar() {
		vivo = true
		posicion = game.at(1,suelo_0.position().y())
	}
}

object multiplicador2XBanner{
	method image() = "src/assets/img/2X.png"
	method position() = game.at(12, game.height()-8)
}