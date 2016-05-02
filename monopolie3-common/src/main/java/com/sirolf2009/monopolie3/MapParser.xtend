package com.sirolf2009.monopolie3

import java.io.File
import jxl.Workbook
import com.sirolf2009.xtend.annotations.Model
import java.util.ArrayList

class MapParser {

	def static parse() {
		val file = new File("src/main/resources/Zalmplaat.xls")
		val workbook = Workbook.getWorkbook(file)
		val sheet = workbook.getSheet(0)
		val streets = new ArrayList<StreetDetails>()

		for (var row = 0; row < sheet.rows; row++) {
			row => [ currentRow |
				streets.add(
					new StreetDetails => [
						name = sheet.getCell(0, currentRow).contents
						x = Integer.parseInt(sheet.getCell(1, currentRow).contents)
						y = Integer.parseInt(sheet.getCell(2, currentRow).contents)
					]
				)
			]
		}
		
		return streets
	}

	@Model public static class StreetDetails {

		String name
		int x
		int y

	}

}
