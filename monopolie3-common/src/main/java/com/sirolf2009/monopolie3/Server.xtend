package com.sirolf2009.monopolie3

import com.esotericsoftware.kryonet.Connection
import com.sirolf2009.monopolie3.model.Chance
import com.sirolf2009.monopolie3.model.Street
import com.sirolf2009.monopolie3.model.Taxes
import com.sirolf2009.monopolie3.model.Team
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Random

@Accessors class Server implements IServer {

	val List<Street> streets

	val Map<Team, Connection> teamToConnection = new HashMap()
	val Map<Connection, Team> connectionToTeam = new HashMap()
	val rand = new Random()

	new(List<Street> streets) {
		this.streets = new ArrayList(streets)
	}

	override getStreet(String name) {
		streets.findFirst[it.name.equals(name)]
	}

	override attemptPurchase(String streetName, String teamName) {
		val street = getStreet(streetName)
		val team = getTeam(teamName)
		if(team.money >= Constants.PRICE_STREET && street.owner == null) {
			team.money -= Constants.PRICE_STREET
			street.owner = team
			return true
		}
		return false
	}
	
	override attemptBuildHouse(String streetName, String teamName) {
		val street = getStreet(streetName)
		val team = getTeam(teamName)
		if(team.name.equals(street.owner.name)) {
			if(team.money >= Constants.PRICE_HOUSE && street.houses < Constants.MAX_HOUSES) {
				team.money -= Constants.PRICE_HOUSE
				street.houses = street.houses + 1
				return true
			}
		}
		return false
	}

	override payTaxes(String streetName, String teamName) {
		val street = getStreet(streetName)
		val visitingTeam = getTeam(teamName)
		val owningTeam = street.owner
		if(owningTeam != null) {
			val taxes = new Taxes(visitingTeam, owningTeam, streetName, Constants.getTaxesForStreet(street))
			visitingTeam.money -= taxes.amount
			owningTeam.money += taxes.amount
			try {
				getConnection(owningTeam).sendTCP(taxes)
			} catch(Exception e) {
				e.printStackTrace
			}
			return taxes
		}
	}

	override getTeam(String teamName) {
		teamToConnection.keySet.findFirst[name.equals(teamName)]
	}

	override getStreetsForTeam(String teamName) {
		val team = getTeam(teamName)
		return new ArrayList(streets.filter[owner?.name?.equals(teamName)].toList)
	}
	
	override drawChanceCard(String teamName) {
		val cards = Chance.cards
		val index = rand.nextInt(cards.size)
		val card = cards.get(index)
		val team = getTeam(teamName)
		card.function.accept(team)
		team.chances--
		return card.description
	}

	// ************************
	// ****Server side only****
	// ************************
	def register(Team team, Connection connection) {
		teamToConnection.put(team, connection)
		connectionToTeam.put(connection, team)
	}

	def getTeam(Connection connection) {
		connectionToTeam.get(connection)
	}

	def getConnection(Team team) {
		teamToConnection.get(team)
	}

	def isTaken(String teamName) {
		getTeam(teamName) != null
	}

	def disconnect(Connection connection) {
		val team = connection.team
		teamToConnection.remove(team)
		connectionToTeam.remove(connection)
	}

	def broadcast(Object object) {
		connectionToTeam.keySet.forEach [
			sendTCP(object)
		]
	}

}
