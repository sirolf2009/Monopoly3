package com.sirolf2009.monopolie3.client.gui

import com.sirolf2009.monopolie3.ClientState
import com.sirolf2009.monopolie3.MapParser.StreetDetails
import com.sirolf2009.monopolie3.client.controller.ControllerMain
import java.util.List
import java.util.stream.Stream
import javafx.scene.control.Alert
import javafx.scene.control.Alert.AlertType
import javafx.scene.control.ButtonType
import javafx.scene.control.MenuButton
import javafx.scene.control.MenuItem
import javafx.scene.layout.AnchorPane
import com.sirolf2009.monopolie3.Constants

class StreetButton extends MenuButton {

	val List<MenuItem> defaultMenu
	val List<MenuItem> visitingUnowned
	val List<MenuItem> visitingOwnedByMe
	val List<MenuItem> visitingOwnedByOther

	new(ControllerMain main, ClientState state, AnchorPane container, StreetDetails details) {
		super(details.name)
		layoutX = details.x
		layoutY = details.y
		styleClass.add("street-button")

		defaultMenu = #[
			new MenuItem("Loop hierheen") => [
				onAction = [ evt |
					container.buttons.forEach[it.reset()]
					val street = state.server.getStreet(details.name)
					if(street.owner == null) {
						visitUnowned()
					} else if(street.owner.name.equals(state.teamName)) {
						visitOwnedByMe()
					} else {
						val taxes = state.server.payTaxes(details.name, state.teamName)
						main.onTeamUpdated()
						new Alert(AlertType.WARNING, "Deze straat is van "+taxes.receiver.name+". Je hebt "+taxes.amount+" betaald.", ButtonType.OK).show()
						visitOwnedByOther()
					}
				]
			]
		]

		visitingUnowned = #[
			new MenuItem("Koop deze straat") => [
				onAction = [ evt |
					if(state.server.attemptPurchase(details.name, state.teamName)) {
						new Alert(AlertType.CONFIRMATION, "Je hebt " + details.name + " gekocht!", ButtonType.OK).show()
						main.onTeamUpdated()
						visitOwnedByMe()
					} else {
						new Alert(AlertType.ERROR, "Je hebt niet genoeg geld om " + details.name + " te kopen", ButtonType.OK).show()
					}
				]
			]
		]

		visitingOwnedByMe = #[
			new MenuItem("Koop een huis") => [
				onAction = [evt |
					if(state.server.attemptBuildHouse(details.name, state.teamName)) {
						new Alert(AlertType.CONFIRMATION, "Je hebt een huis gebouwd!", ButtonType.OK).show()
						main.onTeamUpdated()
					} else {
						if(state.server.getStreet(details.name).houses == Constants.MAX_HOUSES) {
							new Alert(AlertType.ERROR, "Je hebt de straat al volgebouwd", ButtonType.OK).show()
						} else {
							new Alert(AlertType.ERROR, "Te weining geld!", ButtonType.OK).show()
						}
					}
				]
			]
		]
		
		visitingOwnedByOther = #[]

		reset()
	}

	def void reset() {
		items.clear()
		items.addAll(defaultMenu)
		styleClass.removeIf[it.equals("street-button-visiting")]
	}

	def void visitOwnedByMe() {
		items.clear()
		items.addAll(visitingOwnedByMe)
		styleClass.add("street-button-visiting")
	}

	def void visitOwnedByOther() {
		items.clear()
		items.addAll(visitingOwnedByOther)
		styleClass.add("street-button-visiting")
	}

	def void visitUnowned() {
		items.clear()
		items.addAll(visitingUnowned)
		styleClass.add("street-button-visiting")
	}

	def static Stream<StreetButton> buttons(AnchorPane container) {
		container.childrenUnmodifiable.stream.map[it as StreetButton]
	}

}
