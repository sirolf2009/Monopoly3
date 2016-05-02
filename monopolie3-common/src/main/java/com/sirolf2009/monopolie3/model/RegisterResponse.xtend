package com.sirolf2009.monopolie3.model

import com.sirolf2009.xtend.annotations.Model

@Model class RegisterResponse {
	
	public var String team
	public var boolean accepted
	public var boolean hasGameStarted
	public var String errorMessage
	
}