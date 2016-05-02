package com.sirolf2009.monopolie3.client.controller

import com.esotericsoftware.kryonet.Connection
import com.esotericsoftware.kryonet.Listener
import com.sirolf2009.monopolie3.ClientState
import com.sirolf2009.monopolie3.MapParser
import com.sirolf2009.monopolie3.client.gui.StreetButton
import com.sirolf2009.monopolie3.model.Street
import com.sirolf2009.monopolie3.model.Taxes
import eu.hansolo.enzo.notification.Notification.Notifier
import java.text.SimpleDateFormat
import java.util.Date
import javafx.application.Platform
import javafx.event.ActionEvent
import javafx.fxml.FXML
import javafx.scene.Group
import javafx.scene.control.Alert
import javafx.scene.control.Alert.AlertType
import javafx.scene.control.Button
import javafx.scene.control.Label
import javafx.scene.control.ListCell
import javafx.scene.control.ListView
import javafx.scene.control.ScrollPane
import javafx.scene.image.ImageView
import javafx.scene.layout.AnchorPane
import javafx.scene.layout.StackPane
import javafx.scene.transform.Scale
import javafx.util.Callback
import org.eclipse.xtend.lib.annotations.Accessors
import com.sirolf2009.monopolie3.Constants

@Accessors class ControllerMain {

	@FXML ScrollPane mapScrollPane
	@FXML StackPane mapContainer
	@FXML ImageView map
	@FXML AnchorPane buttons
	@FXML Button zoomIn
	@FXML Button zoomOut

	@FXML Label money
	@FXML Label teamName
	@FXML ListView<Street> streets

	@FXML Label chanceCountLabel
	@FXML Label chanceTimeoutLabel

	public static ClientState client

	long chanceTimout = 0
	static val timeFormat = new SimpleDateFormat("mm:ss")

	@FXML
	def void initialize() {
		val contentGroup = new Group()
		val zoomGroup = new Group()
		contentGroup.children.add(zoomGroup)
		zoomGroup.children.add(mapContainer)
		mapScrollPane.content = contentGroup
		val scale = new Scale(1, 1)
		zoomGroup.transforms.add(scale)
		zoomIn.onAction = [
			scale.x = scale.x + 0.5
			scale.y = scale.y + 0.5
		]
		zoomOut.onAction = [
			if(scale.x == 1) {
				return
			}
			scale.x = scale.x - 0.5
			scale.y = scale.y - 0.5
		]

		MapParser.parse.forEach [ street |
			val button = new StreetButton(this, client, buttons, street)
			buttons.children.add(button)
		]

		client.client.addListener(new Listener() {

			override received(Connection arg0, Object arg1) {
				if(arg1 instanceof Taxes) {
					val packet = arg1 as Taxes
					if(packet.receiver.name == client.teamName) {
						Platform.runLater [
							Notifier.INSTANCE.notifyInfo("Huur", packet.payer.name + " heeft " + packet.amount + " betaald voor " + packet.streetName)
						]
						onTeamUpdated()
					}
				}
			}

		})

		streets.cellFactory = new Callback<ListView<Street>, ListCell<Street>>() {
			override call(ListView<Street> param) {
				new ListCell<Street>() {
					override protected updateItem(Street item, boolean empty) {
						super.updateItem(item, empty)
						if(item != null) {
							text = item.name
						}
					}

				}
			}
		}

		onTeamUpdated()

		new Thread [
			while(true) {
				Platform.runLater [
					chanceTimeoutLabel.text = chanceTimout.format()
					chanceTimeoutLabel.visible = chanceTimout > 0
				]
				Thread.sleep(1000)
				chanceTimout -= 1000
			}
		].start()
	}

	def onTeamUpdated() {
		new Thread [
			val team = client.team
			val ownedStreets = client.server.getStreetsForTeam(team.name)
			Platform.runLater [
				teamName.text = team.name
				money.text = team.money + ""
				streets.items.clear()
				streets.items.addAll(ownedStreets)
				chanceCountLabel.text = team.chances+""
			]
		].start
	}

	def drawChance(ActionEvent event) {
		val chanceCount = client.team.chances
		if(chanceTimout <= 0 && chanceCount > 0) {
			val description = client.server.drawChanceCard(client.teamName)
			onTeamUpdated()
			chanceCountLabel.text = chanceCount + ""
			chanceTimout = Constants.CHANCE_CARDS_COOLDOWN
			val alert = new Alert(AlertType.INFORMATION)
			alert.contentText = description
			alert.resizable = true
			alert.show()
//			new Alert(AlertType.INFORMATION, description).show()
		} else if(chanceTimout > 0) {
			new Alert(AlertType.ERROR, chanceTimout.format()).show()
		} else {
			new Alert(AlertType.ERROR, "Je hebt geen kanskaarten meer").show()
		}
	}

	def static format(long millis) {
		return "Je moet nog " + timeFormat.format(new Date(millis)) + " wachten"
	}

}
