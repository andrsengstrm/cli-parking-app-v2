# Parkeringsapp v 1.0.0
Det här är min cli-baserade dart-app för att hantera parkeringar.

## Beskrivning
Appen har följande komponenter:

- Models för person, fordon, parkeringsplats och parkering. Dessa models har olika värden beroende på vad som behövs, t.ex. namn och personnr för Ägare, Pris per timme för Pakeringsplatser o.s.v. Alla objekt i dessa olika models får ett unikt id (uid) när de skapas. En model kan ingå i en annan model, t.ex. alla Fordon har en Ägare som är objektet Person, en Parkering har objekten Fordon och Parkeringsplats. Dessa refereras med faktiska värden när de skapas. Man skulle kunna referera dessa via en referens istället (id för objeketet), då skulle alla objekt där referensen finns automatiskt uppdateras när man uppdaterar objektet självt. Det kan vara en fördel i vissa fall och en nackdel i andra fall.
Det finns även funktioner för att serialsera och deserialisera JSON i varje Model. I Model för Parkeringar så finns också en funktion för att räkna ut aktuell kostnad för varje parkering.

- Repositories: Alla models har en egen repository som ärver från den abstrakta klassen för repository. Den abstrakta klassen innehåller CRUD för anonyma objekt som ärvs till varje klass, jag har lagt till en funktion för att hitta ett objekt via objeketets id i varje enskilt repo (som inte går med ett anonymt objekt).

- Menu: Här finns hanteringen av varje del i applikationen. Ägare, Fordon, Parkeringsplatser och Parkeringar. Jag har byggt in felhantering för att ta hand om inmatningsfel, och viss validering av val där man väljer objekt från ett index.


