package com.sirolf2009.monopolie3.model.packet

import com.sirolf2009.xtend.annotations.Model

@Model class PacketStreetVisitResponse {
	
	int response //0 = taxes, 1 = you're the owner, 2 = no one owns the street
	int taxes //may be 0
	String ownerName // may be null
	
	new(int response) {
		this.response = response
	}
	
}