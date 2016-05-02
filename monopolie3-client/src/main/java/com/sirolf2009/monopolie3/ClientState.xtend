package com.sirolf2009.monopolie3

import com.esotericsoftware.kryonet.Client
import com.esotericsoftware.kryonet.Connection
import com.esotericsoftware.kryonet.rmi.ObjectSpace
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class ClientState {
	
	val String teamName
	val Client client
	val Connection connection
	val ObjectSpace objectSpace
	
	new(String teamName, Client client, Connection connection) {
		this.teamName = teamName
		this.client = client
		this.connection = connection
		
		ObjectSpace.registerClasses(client.kryo)
		objectSpace = new ObjectSpace()
	}
	
	def getServer() {
		ObjectSpace.getRemoteObject(connection, 0, IServer)
	}
	
	def sendTCP(Object object) {
		client.sendTCP(object)
	}
	
	def getTeam() {
		server.getTeam(teamName)
	}
	
}