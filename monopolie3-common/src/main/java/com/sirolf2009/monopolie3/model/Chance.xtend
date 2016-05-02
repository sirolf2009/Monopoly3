package com.sirolf2009.monopolie3.model

import com.sirolf2009.monopolie3.model.Team
import java.util.function.Consumer
import org.eclipse.xtend.lib.annotations.Data

@Data class Chance {
	
	val String description
	val Consumer<Team> function
	
	public static val cards = #[
		new Chance("Boete voor te snel rijden ƒ 50", [money -= 50]),
		new Chance("Betaal uw doktersrekening ƒ 50", [money -= 50]),
		new Chance("Betaal uw verzekeringspremie ƒ 50", [money -= 50]),
		new Chance("Betaal het hospitaal ƒ 100", [money -= 100]),
		new Chance("Betaal schoolgeld ƒ 150", [money -= 150]),
		new Chance("Betaal uw doktersrekening ƒ 50", [money -= 50]),
		new Chance("Aangehouden wegens dronkenschap ƒ 20 boete", [money -= 20]),
		new Chance("Een vergissing van de bank in uw voordeel, u ontvangt ƒ 200", [money -= 50]),
		new Chance("Betaal uw verzekeringspremie ƒ 50", [money -= 50]),
		new Chance("De bank betaalt u ƒ 50 dividend", [money += 50]),
		new Chance("Uw bouwverzekering vervalt, u ontvangt ƒ 150", [money += 150]),
		new Chance("U heeft een kruiswoordpuzzel gewonnen en ontvangt ƒ 100", [money += 50]),
		new Chance("U erft ƒ 100", [money += 100]),
		new Chance("U ontvangt rente van 7% preferent aandelen ƒ 25", [money += 25]),
		new Chance("U hebt de tweede prijs in een schoonheidswedstrijd gewonnen en ontvangt ƒ 10", [money += 10]),
		new Chance("Door verkoop van effecten ontvangt u ƒ 50", [money += 50]),
		new Chance("Restitutie inkomstenbelasting, u ontvangt ƒ 20", [money += 20]),
		new Chance("Lijfrente vervalt, u ontvangt ƒ 100", [money += 100])
	]
	
}
