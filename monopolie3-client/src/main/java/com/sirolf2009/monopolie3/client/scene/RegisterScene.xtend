package com.sirolf2009.monopolie3.client.scene

import javafx.geometry.Insets
import javafx.geometry.Pos
import javafx.scene.Scene
import javafx.scene.control.Button
import javafx.scene.control.TextField
import javafx.scene.layout.StackPane
import javafx.scene.layout.VBox
import javafx.scene.layout.HBox
import javafx.scene.control.Label

class RegisterScene extends Scene {

	new() {
		super(new StackPane =>
			[
				setStyle("-fx-background-image: url('splash.png'); " + "-fx-background-position: center center; " +
					"-fx-background-repeat: stretch;");
				alignment = Pos.CENTER
				children += new HBox => [
					children += new VBox => [
						children += new Label("Team: ")
						children += new TextField => [
							promptText = "Team naam"
							textProperty.addListener [ listener |
								println(it.text)
							]
						]
					]
					children += new Button => [
						text = "OK"
						padding = new Insets(64, 0, 0, 0)
						onAction = [
							println(it)
						]
					]
				]
			], 1024, 800)
	}

}