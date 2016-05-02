package com.sirolf2009.monopolie3

import java.io.FileInputStream
import javafx.fxml.FXMLLoader
import javafx.scene.Parent
import javafx.scene.Scene
import javafx.stage.Stage
import xtendfx.FXApp
import javafx.event.EventHandler
import javafx.stage.WindowEvent

@FXApp class Monopoly {
	
	override start(Stage it) throws Exception {
		val fxmlFile = "src/main/resources/register.fxml"
		val loader = new FXMLLoader()
		val rootNode = loader.load(new FileInputStream(fxmlFile)) as Parent

		val scene = new Scene(rootNode) => [
			stylesheets += #["MaterialDesign.css", "monopolie.css"]
		]

		setTitle("Monopolie")
		setScene(scene)
		onCloseRequest = new EventHandler<WindowEvent>() {
			
			override handle(WindowEvent event) {
				System.exit(0)
			}
			
		}
		show()
	}
	
}