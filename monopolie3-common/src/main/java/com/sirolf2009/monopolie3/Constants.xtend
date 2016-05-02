package com.sirolf2009.monopolie3

import com.sirolf2009.monopolie3.model.Register
import com.sirolf2009.monopolie3.model.RegisterResponse
import com.sirolf2009.monopolie3.model.Street
import com.sirolf2009.monopolie3.model.Taxes
import com.sirolf2009.monopolie3.model.Team
import com.sirolf2009.monopolie3.model.packet.PacketStartGame
import com.sirolf2009.monopolie3.model.packet.PacketStreetVisit
import com.sirolf2009.monopolie3.model.packet.PacketStreetVisitResponse
import java.util.ArrayList
import javafx.beans.property.SimpleDoubleProperty
import javafx.beans.property.SimpleStringProperty
import java.time.Duration

class Constants {
	
	public static val SERVER_TCP_PORT = 1941;
	public static val SERVER_UDP_PORT = 1942;
	
	public static val PACKETS = #[Register, RegisterResponse, PacketStartGame, PacketStreetVisit, PacketStreetVisitResponse, Team, SimpleDoubleProperty, SimpleStringProperty, IServer, ArrayList, Street, Taxes]
	
	public static val STARTING_MONEY = 2000
	public static val PRICE_STREET = 150
	public static val PRICE_HOUSE = 100
	public static val MAX_HOUSES = 4
	
	public static val CHANCE_CARDS_AMOUNT = 5
	public static val CHANCE_CARDS_COOLDOWN = Duration.ofMinutes(5).toMillis
	
	def static getTaxesForStreet(Street street) {
		var price = 50
		for(var i = 0; i < street.houses; i++) {
			price *= 2
		}
		return price
	}
	
}