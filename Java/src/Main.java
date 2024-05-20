import java.util.Scanner;

public class Main {
	public static void waitForEnter() {
		System.out.println("\nΠατήστε Enter...");
		try {
			System.in.read();
			System.in.close();
		} catch (Exception e) {
		}
	}

	public static void showMenu() {
		System.out.println("\nΔιαθέσιμες Ενέργειες:");
		System.out.println("1. Σύνδεση στην βάση δεδομένων.");
		System.out.println("2. Αποσύνδεση από τη βάση δεδομένων.");
		System.out.println("3. Προβολή βαθμολογίας ενός φοιτητή για συγκεκριμένο εξάμηνο.");
		System.out.println("4. Εισαγωγή εργασιών και ομάδων εργασίας για συγκεκριμένο μάθημα.");
		System.out.println(
				"5. Εισαγωγή εργασιών και ομάδων εργασίας για όλα τα μαθήματα συγκεκριμένου γνωστικού αντικειμένου.");
		System.out.println("6. Έξοδος.");
		System.out.println("\nΕισάγετε την επιλογή σας:");
	}

	public static void main(String[] args) {
		try {
			DbApp app = new DbApp();
			Scanner sc = new Scanner(System.in);
			String amka = null, season = null, course = null, sector = null;
			Integer choice = null, year = null, serialNumber = null, modules = null, groups = null;

			do {
				showMenu();
				choice = sc.nextInt();
				sc.nextLine();

				switch (choice) {
					case 1:
						app.dbConnect("localhost", "PhaseB", "postgres", "akis");
						break;

					case 2:
						app.dbDisconnect();
						break;

					case 3:
						System.out.println("Εισάγετε το ΑΜΚΑ του φοιτητή:");
						amka = sc.nextLine();

						System.out.println("Εισάγετε ακαδημαϊκό έτος:");
						year = sc.nextInt();
						sc.nextLine();

						System.out.println("Εισάγετε εποχή (spring/winter):");
						season = sc.nextLine();

						app.showGrades(amka, year, season);
						break;

					case 4:
						System.out.println("Εισάγετε κωδικό μαθήματος:");
						course = sc.nextLine();

						System.out.println("Εισάγετε τον αριθμό σειριακής εκτέλεσης του μαθήματος:");
						serialNumber = sc.nextInt();
						sc.nextLine();

						System.out.println("Εισάγετε τον επιθυμητό αριθμό εργασιών:");
						modules = sc.nextInt();
						sc.nextLine();

						System.out.println("Εισάγετε τον επιθυμητό αριθμό ομάδων:");
						groups = sc.nextInt();
						sc.nextLine();

						app.insertModulesGroups(course, serialNumber, modules, groups);
						break;

					case 5:
						System.out.println("Εισάγετε γνωστικό αντικείμενο (ΠΛΗ, ΤΗΛ, ΜΑΘ, κλπ):");
						sector = sc.nextLine();

						System.out.println("Εισάγετε τον επιθυμητό αριθμό εργασιών:");
						modules = sc.nextInt();
						sc.nextLine();

						System.out.println("Εισάγετε τον επιθυμητό αριθμό ομάδων:");
						groups = sc.nextInt();
						sc.nextLine();

						app.insertModulesGroupsPerSector(sector, modules, groups);
						break;

					case 6:
						app.dbDisconnect();
						System.out.println("Αντίο.");
						break;

					default:
						System.out.println("Λάθος επιλογή.");
						break;
				}

				// waitForEnter();
			} while (choice != 6);

			sc.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
