import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;

import org.apache.commons.dbutils.DbUtils;

public class DbApp {
	static Connection conn = null;

	public DbApp() {
	}

	// Connects to the database.
	public void dbConnect(String ip, String dbName, String username, String password) throws SQLException {
		try {
			conn = DriverManager.getConnection("jdbc:postgresql://" + ip + ":5432/" + dbName, username, password);
			System.out.println("Έγινε σύνδεση: " + conn);
		} catch (SQLException e) {
			System.out.println("SQLException: " + e.getMessage());
			System.out.println("SQLState: " + e.getSQLState());
			System.out.println("VendorError: " + e.getErrorCode());
			throw e;
		}
	}

	public void dbDisconnect() {
		DbUtils.closeQuietly(conn);
		System.out.println("Έγινε αποσύνδεση.");
	}

	// Prints the student's info by calling the showStudentInfo() method. Then,
	// it sends a query to the database that returns the lab modules the student
	// has completed for the given semester and prints those query results.
	public void showGrades(String amka, Integer year, String season) {
		PreparedStatement st = null;
		ResultSet rs = null;
		Boolean studFlag = false;

		studFlag = this.showStudentInfo(amka);
		if (studFlag)
			try {
				st = conn.prepareStatement(
						"select course_code, title, grade from \"Joins\" natural join \"Workgroup\" natural join \"LabModule\" sub "
								+ "where amka = ? and exists (select course_code, serial_number from \"CourseRun\" cr "
								+ "where sub.course_code = cr.course_code and sub.serial_number = cr.serial_number and semesterrunsin = "
								+ "(select semester_id from \"Semester\" where academic_year = ? and academic_season = ?::semester_season_type)) "
								+ "order by course_code asc");
				st.setString(1, amka);
				st.setInt(2, year);
				st.setString(3, season);
				rs = st.executeQuery();

				if (rs.next()) {
					System.out.println("\nΕργασίες Φοιτητή:");
					System.out.println("Μάθημα\t\tΤίτλος\t\t\t\t\tΒαθμός");
					do {
						System.out.println(rs.getString(1) + "\t\t" + rs.getString(2) + "\t\t" + rs.getString(3));
					} while (rs.next());
				} else
					System.out.println("\nΔεν βρέθηκαν εργασίες για τον φοιτητή για το συγκεκριμένο εξάμηνο.");
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				DbUtils.closeQuietly(rs);
				DbUtils.closeQuietly(st);
			}
	}

	// Sends a query to get the student's info for a given amka and then prints
	// the query results. Returns true if a student is found, false otherwise.
	public Boolean showStudentInfo(String amka) {
		PreparedStatement st = null;
		ResultSet rs = null;
		Boolean flag = false;

		try {
			st = conn.prepareStatement(
					"select name, surname, father_name, am, amka, email from \"Student\" natural join \"Person\" where amka = ?");
			st.setString(1, amka);
			rs = st.executeQuery();

			if (rs.next()) {
				flag = true;
				System.out.println("\nΣτοιχεία Φοιτητή:");
				System.out.println("Ονοματεπώνυμο: " + rs.getString(1) + " " + rs.getString(2));
				System.out.println("Όνομα Πατρός: " + rs.getString(3));
				System.out.println("ΑΜ: " + rs.getString(4));
				System.out.println("ΑΜΚΑ: " + rs.getString(5));
				System.out.println("email: " + rs.getString(6));
			} else
				System.out.println("\nΔεν βρέθηκε φοιτητής με αυτό το ΑΜΚΑ.");
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DbUtils.closeQuietly(rs);
			DbUtils.closeQuietly(st);
		}

		return flag;
	}

	// Inserts the specified number of lab modules for the given course code and
	// serial number and then inserts the specified number of work groups for each
	// of those lab modules.
	public void insertModulesGroups(String course, Integer serialNumber, Integer modules, Integer groups) {
		Random rand = new Random();
		PreparedStatement modSt = null;
		PreparedStatement groupSt = null;
		Integer newMod = this.getNewModuleNo(course, serialNumber);

		try {
			modSt = conn.prepareStatement("insert into \"LabModule\" values(?, ?, ?, ?::labmodule_type, ?, ?, ?)");
			groupSt = conn.prepareStatement("insert into \"Workgroup\" values(?, ?, ?, ?, ?)");

			System.out.println("\nInserting lab modules and work groups...");
			for (int i = newMod; i < modules + newMod; i++) {
				modSt.setString(1, course);
				modSt.setInt(2, serialNumber);
				modSt.setInt(3, i);
				if (rand.nextDouble() <= 0.2)
					modSt.setString(4, "project");
				else
					modSt.setString(4, "lab_exercise");
				modSt.setString(5, course + " " + serialNumber + " LabModule Title " + i);
				modSt.setInt(6, rand.nextInt(4) + 2);
				modSt.setInt(7, 10);
				modSt.executeUpdate();

				for (int j = 1; j < groups + 1; j++) {
					groupSt.setString(1, course);
					groupSt.setInt(2, serialNumber);
					groupSt.setInt(3, i);
					groupSt.setInt(4, j);
					groupSt.setDouble(5, BigDecimal.valueOf(6 + rand.nextGaussian() * 2)
							.setScale(1, RoundingMode.HALF_UP)
							.doubleValue());
					groupSt.executeUpdate();
				}
			}

			System.out.println("Insertion completed successfully.");
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DbUtils.closeQuietly(modSt);
			DbUtils.closeQuietly(groupSt);
		}
	}

	// Sends a query to find and return the max module number + 1 for the given
	// course code and serial number.
	public Integer getNewModuleNo(String course, Integer serialNumber) {
		PreparedStatement st = null;
		ResultSet rs = null;
		Integer newMod = null;

		try {
			st = conn.prepareStatement(
					"select coalesce(max(module_no), 0) + 1 from \"LabModule\" where course_code = ? and serial_number = ?");
			st.setString(1, course);
			st.setInt(2, serialNumber);
			rs = st.executeQuery();

			if (rs.next())
				newMod = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DbUtils.closeQuietly(rs);
			DbUtils.closeQuietly(st);
		}

		return newMod;
	}

	// Sends a query to find and return the max work group ID + 1 for the given
	// course code, serial number and lab module number. This method is not used.
	public Integer getNewGroupID(String course, Integer serialNumber, Integer moduleNumber) {
		PreparedStatement st = null;
		ResultSet rs = null;
		Integer newID = null;

		try {
			st = conn.prepareStatement(
					"select coalesce(max(\"wgID\"), 0) + 1 from \"Workgroup\" where course_code = ? and serial_number = ? and module_no = ?");
			st.setString(1, course);
			st.setInt(2, serialNumber);
			st.setInt(3, moduleNumber);
			rs = st.executeQuery();

			if (rs.next())
				newID = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DbUtils.closeQuietly(rs);
			DbUtils.closeQuietly(st);
		}

		return newID;
	}

	// Sends a query to find all the course codes and serial numbers of the given
	// sector and then calls insertModulesGroups() as needed.
	public void insertModulesGroupsPerSector(String sector, Integer modules, Integer groups) {
		PreparedStatement st = null;
		ResultSet rs = null;

		try {
			st = conn.prepareStatement(
					"select course_code, serial_number from \"CourseRun\" where course_code like ? and labuses is not null");
			st.setString(1, sector + " ___");
			rs = st.executeQuery();

			if (rs.next()) {
				System.out.println("\nInserting lab modules and work groups...");
				do {
					this.insertModulesGroups(rs.getString(1), rs.getInt(2), modules, groups);
				} while (rs.next());

				System.out.println("Insertion completed successfully.");
			} else
				System.out.println("\nΔεν υπάρχουν εργαστηριακά μαθήματα με αυτό το γνωστικό αντικείμενο.");
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DbUtils.closeQuietly(rs);
			DbUtils.closeQuietly(st);
		}
	}
}
