import wollok.game.*
   
const color = "535353FF" 
const velocidadContador = 250
const velocidad = 250
const movimiento = 10

object juego{

	var hiScore = 0

	method configurar(){
		game.cellSize(5)
		game.width(120)
		game.height(80)
		game.title("Dino Game")
		game.addVisual(menuInicio)
		game.boardGround("fondo.png")
		keyboard.s().onPressDo{
			self.configurarJuego()
			self.iniciar()
		}
		keyboard.e().onPressDo{
			
		}
	} 
	
	method configurarJuego(){
		game.removeVisual(menuInicio)
		game.addVisual(suelo_0)
		game.addVisual(suelo_1)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(maxScore)
		game.addVisual(otroDino)
		keyboard.space().onPressDo{self.jugar()}
		
		//Implementar cuando se mantiene la tecla
		keyboard.left().onPressDo{dino.moverIzquierda()}
		keyboard.right().onPressDo{dino.moverDerecha()}
		//game.onCollideDo(dino,{obstaculo => obstaculo.chocar()})
	}
	
	method iniciar(){
		game.onTick(velocidad/2.5,"movimiento",{self.iniciarMovimiento()})
		suelo_0.iniciar()
		suelo_1.iniciar()
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		otroDino.iniciar()
	}
	
	method iniciarMovimiento(){
		cactus.mover()
		suelo_0.mover()
		suelo_1.mover()
		otroDino.mover()
		reloj.pasarTiempo()
		if (dino.posicion().distance(cactus.posicion()) < 7){
			cactus.chocar()
		}
		if (dino.posicion().distance(otroDino.posicion()) < 7){
			otroDino.chocar()
		}
	}
	
	method detenerMovimiento(){
		game.removeTickEvent("movimiento")
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method hiScore(){
		return hiScore
	}
	
	method terminar(){
		game.addVisual(gameOver)
		self.detenerMovimiento()
		dino.morir()
		if (hiScore < reloj.tiempo()) {
			hiScore = reloj.tiempo()
		}
	}
	
}

object menuInicio {
	method position() = game.origin().right(15).down(5)
	method image() = "menuInicio.png"
}

object gameOver {
	method position() = game.center().left(30).down(30)
	method image() = "gameOver.png"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method textColor() = color
	method position() = game.at(1, game.height()-10)
	
	method pasarTiempo() {
		tiempo = tiempo + 1
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

	method image() = "cactus.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
	}
	
	method mover(){
		position = position.left(movimiento)
		modificador = (new Range(start = 1, end = 50).anyOne()).div(10) * 10
		if (position.x() == -10){
			position = game.at(game.width()+modificador, suelo_0.position().y())
		}
	}
	
	method posicion(){
		return position
	}
	
	method chocar(){
		juego.terminar()
	}
}

object otroDino{
	
	const posicionInicial = game.at(game.width()+50, suelo_0.position().y())
	var position = posicionInicial
	var modificador = 50
	
	method image() = "otroDino.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
	}
	
	method mover(){
		position = position.left(movimiento)
		if (position.x() == -10){
			modificador = (new Range(start = 1, end = 50).anyOne()).div(10) * 10
			position = game.at(game.width()+modificador, suelo_0.position().y())
		}
	}
	
	method chocar(){
		juego.terminar()
	}
	
	method posicion(){
		return position
	}
}

object suelo_0{
	const posicionInicial = game.origin().up(1)
	var posicion = posicionInicial
	
	method position() = posicion
	
	method image() = "suelo.png"
	
	method chocar(){
		
	}
	
	method iniciar(){
		posicion = posicionInicial
	}
	
	method mover(){
		posicion = posicion.left(movimiento)
		if (posicion.x() == -120)
			posicion = game.origin().up(1).right(120)
	}
}

object suelo_1{
	const posicionInicial = game.origin().up(1).right(120)
	var posicion = posicionInicial
	
	method position() = posicion
	
	method image() = "suelo.png"
	
	method chocar(){
		
	}
	
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
	
	method image(){
		//game.onTick(1000, "dinoCorrer", {self.correr()})
		return "dino_1.png"
	}
	
	method position() = position
	
	method saltar(){
		if(position.y() == suelo_0.position().y()) {
			self.subir()
			game.schedule(velocidad*2,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(10)
	}
	
	method bajar(){
		position = position.down(10)
	}
	
	method moverIzquierda(){
		position = position.left(1)
	}
	
	method moverDerecha(){
		position = position.right(1)
	}
	
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
}