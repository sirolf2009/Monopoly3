package com.sirolf2009.monopolie3.server

import com.sirolf2009.monopolie3.model.Team
import java.util.ArrayList
import java.util.List
import com.sirolf2009.monopolie3.Constants

class Teams {
	
	private static val List<Team> teams = new ArrayList()
	
	def static Team getTeam(String name) {
		teams.stream.filter[it.name == name].findAny.orElseGet[
			val newTeam = new Team => [
				it.name = name
				it.money = Constants.STARTING_MONEY
				it.chances = Constants.CHANCE_CARDS_AMOUNT
			]
			teams.add(newTeam)
			return newTeam
		]
	}
	
}