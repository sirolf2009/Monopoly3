package com.sirolf2009.monopolie3.model

import com.sirolf2009.xtend.annotations.Model

@Model class Taxes {
	
	var Team payer
	var Team receiver
	var String streetName
	var int amount
	
}