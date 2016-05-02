package com.sirolf2009.monopolie3

import com.sirolf2009.monopolie3.model.Street
import com.sirolf2009.monopolie3.model.Taxes
import com.sirolf2009.monopolie3.model.Team
import java.util.List

interface IServer {
	
	def List<Street> getStreets()
	def Street getStreet(String name)
	
	def Team getTeam(String name)
	def List<Street> getStreetsForTeam(String teamName)
	
	def boolean attemptPurchase(String streetName, String teamName)
	def boolean attemptBuildHouse(String streetName, String teamName)
	
	def Taxes payTaxes(String string, String string2)
	
	def String drawChanceCard(String teamName)
	
}
