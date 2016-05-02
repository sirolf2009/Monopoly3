package com.sirolf2009.monopolie3.server.model

import com.esotericsoftware.kryonet.Connection
import com.sirolf2009.monopolie3.model.Team
import com.sirolf2009.xtend.annotations.Model

@Model class Client {
	
	var Connection connection
	var Team team
	
}