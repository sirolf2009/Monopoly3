package com.sirolf2009.monopolie3.client.controller

import com.esotericsoftware.kryonet.Client
import com.esotericsoftware.kryonet.Connection
import com.esotericsoftware.kryonet.Listener
import com.sirolf2009.monopolie3.ClientState
import com.sirolf2009.monopolie3.Constants
import com.sirolf2009.monopolie3.model.Register
import com.sirolf2009.monopolie3.model.RegisterResponse
import com.sirolf2009.monopolie3.model.packet.PacketStartGame
import java.io.FileInputStream
import javafx.application.Platform
import javafx.event.ActionEvent
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.Scene
import javafx.scene.control.Button
import javafx.scene.control.Label
import javafx.scene.control.TextField
import javafx.scene.layout.VBox
import javafx.stage.Stage
import nl.kii.async.annotation.Async

import static com.sirolf2009.monopolie3.client.controller.ControllerMain.*

public class ControllerRegister {

	@FXML VBox registerCard
	@FXML TextField teamName
	@FXML Label errorMessage

	@FXML VBox statusCard
	@FXML Label statusMessage
	
	var String team

	@FXML
	def initialize() {
	}

	def onStartClicked(ActionEvent event) {
		if(teamName.text.empty) {
			errorMessage.visible = true
		} else {
			registerCard.visible = false
			statusCard.visible = true
			statusMessage.text = "Zoeken naar de server"
			statusMessage.text = "Verbinden met de server"
			connect(event)
		}
	}

	@Async def connect(ActionEvent event) {
		val client = new Client
		val address = client.discoverHost(Constants.SERVER_UDP_PORT, 5000)
		Constants.PACKETS.forEach[packet|client.kryo.register(packet)]
		client.start

		client.addListener(new Listener() {

			override received(Connection arg0, Object arg1) {
				if(arg1 instanceof RegisterResponse) {
					val response = arg1 as RegisterResponse
					if(response.accepted && response.hasGameStarted) {
						showMain(event, response.team, client, arg0)
					} else if(response.accepted) {
						team = response.team
						Platform.runLater [
							statusMessage.text = "Wachten tot het spel begint"
						]
					} else {
						Platform.runLater [
							statusMessage.text = response.errorMessage
						]
					}
				} else if(arg1 instanceof PacketStartGame) {
					showMain(event, team, client, arg0)
				}
			}

		})

		client.connect(5000, address, Constants.SERVER_TCP_PORT, Constants.SERVER_UDP_PORT)
		client.sendTCP(new Register() => [
			teamName = this.teamName.text
		])
	}

	def showMain(ActionEvent event, String teamName, Client client, Connection connection) {
		ControllerMain.client = new ClientState(teamName, client, connection)
		Platform.runLater [
			val stage = (event.source as Button).scene.window as Stage
			val newRoot = new FXMLLoader().load(new FileInputStream("src/main/resources/status.fxml"))
			val scene = new Scene(newRoot)
			scene.stylesheets += #["MaterialDesign.css", "monopolie.css"]
			stage.scene = scene
		]
	}

}
