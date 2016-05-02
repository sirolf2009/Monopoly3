package com.sirolf2009.monopolie3.server

import java.io.FileInputStream
import javafx.fxml.FXMLLoader
import javafx.scene.Parent
import javafx.scene.Scene
import javafx.stage.Stage
import xtendfx.FXApp

@FXApp class MonopolyServer {
	
	override start(Stage it) throws Exception {
		val fxmlFile = "src/main/resources/server.fxml"
		val loader = new FXMLLoader()
		val rootNode = loader.load(new FileInputStream(fxmlFile)) as Parent

		val scene = new Scene(rootNode) => [
			stylesheets += #["MaterialDesign.css", "monopolie-server.css"]
		]

		setTitle("Monopolie")
		setScene(scene)
		show()
	}
	
}