package com.sirolf2009.monopolie3.server

import com.esotericsoftware.kryonet.Connection
import com.esotericsoftware.kryonet.FrameworkMessage.KeepAlive
import com.esotericsoftware.kryonet.Listener
import com.esotericsoftware.kryonet.Server
import com.esotericsoftware.kryonet.rmi.ObjectSpace
import com.esotericsoftware.kryonet.rmi.ObjectSpace.InvokeMethod
import com.sirolf2009.monopolie3.Constants
import com.sirolf2009.monopolie3.MapParser
import com.sirolf2009.monopolie3.model.Register
import com.sirolf2009.monopolie3.model.RegisterResponse
import com.sirolf2009.monopolie3.model.Street
import com.sirolf2009.monopolie3.model.packet.PacketStartGame
import eu.hansolo.enzo.notification.Notification.Notifier
import java.util.Arrays
import javafx.application.Platform
import javafx.fxml.FXML
import javafx.scene.control.Button
import javafx.scene.control.TextArea
import javafx.scene.layout.StackPane
import nl.kii.async.annotation.Async
import nl.kii.promise.Task

class ControllerServer {

	@FXML var TextArea console
	@FXML var Button buttonStart

	val server = new com.sirolf2009.monopolie3.Server(MapParser.parse().map[new Street(null, 0, name, x, y)])
	var boolean hasGameStarted

	@FXML
	def void initialize() {
		log("Starting up...")
		log("Initializing server")
		new Server() => [
			bind(Constants.SERVER_TCP_PORT, Constants.SERVER_UDP_PORT)
			Constants.PACKETS.forEach[packet|kryo.register(packet)]
			
			ObjectSpace.registerClasses(kryo)
			val objectSpace = new ObjectSpace()
			objectSpace.register(0, server)
			
			addListener(new Listener() {
				override connected(Connection arg0) {
					objectSpace.addConnection(arg0)
					arg0.name = arg0.remoteAddressTCP.address.toString
					log(arg0 + " connected with ping " + arg0.returnTripTime)
				}

				override disconnected(Connection arg0) {
					log(arg0 + " disconnected")
					server.disconnect(arg0)
				}

				override received(Connection arg0, Object arg1) {
					if(arg1 instanceof KeepAlive) {
					} else if(arg1 instanceof InvokeMethod) {
						val method = arg1 as InvokeMethod
						log(arg0+": "+(method.method.name)+" -> "+Arrays.toString(method.args))
					} else {
						log(arg0+": "+arg1)
					}
					if(arg1 instanceof Register) {
						val register = arg1 as Register
						if(!server.isTaken(register.teamName)) {
							val team = Teams.getTeam(register.teamName)
							server.register(team, arg0)
							Platform.runLater [
								Notifier.INSTANCE.notifyInfo("Connected", register.teamName + " connected")
							]
							log(arg0 + " identifies as " + register.teamName)
							arg0.name = register.teamName
							arg0.sendTCP(new RegisterResponse(register.teamName, true, hasGameStarted, ""))
						} else {
							arg0.sendTCP(new RegisterResponse(null, false, hasGameStarted, "Deze teamnaam is al in gebruik!"))
						}
					}
				}
			})
			start
		]

		buttonStart.onAction = [
			hasGameStarted = true
			((source as Button).parent as StackPane).children.remove(source)
			notifyClientsOfStart()
		]
	}
	
	def void log(String msg) {
		console.text = console.text + msg + "\n"
	}

	@Async def Task notifyClientsOfStart() {
		val task = new Task()
		server.broadcast(new PacketStartGame())
		task.complete()
		return task
	}

}
