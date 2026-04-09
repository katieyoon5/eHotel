package com.demo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Employee {

    private int ssn;
    private String firstName;
    private String middleName;
    private String lastName;
    private String address;
    private String role;
    private int hotelId;

    public Employee(int ssn, String firstName, String middleName, String lastName,
                    String address, String role, int hotelId) {
        this.ssn = ssn;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.address = address;
        this.role = role;
        this.hotelId = hotelId;
    }
    public int getSSN() { return ssn; }
    public String getFirstName() { return firstName; }
    public String getMiddleName() { return middleName; }
    public String getLastName() { return lastName; }
    public String getAddress() { return address; }
    public String getRole() { return role; }
    public int getHotelId() { return hotelId; }

    // get all employees
    public static List<Employee> getEmployees() throws Exception {
        List<Employee> employees = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT ssn, firstname, middlename, lastname, address, role, hotel_id FROM Employee";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                employees.add(new Employee(
                        rs.getInt("ssn"),
                        rs.getString("firstname"),
                        rs.getString("middlename"),
                        rs.getString("lastname"),
                        rs.getString("address"),
                        rs.getString("role"),
                        rs.getInt("hotel_id")
                ));
            }
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return employees;
    }
    // get employe by ssn
    public static Employee getEmployeeBySSN(int ssn) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT ssn, firstname, middlename, lastname, address, role, hotel_id FROM Employee WHERE ssn = ?";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, ssn);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Employee(
                        rs.getInt("ssn"),
                        rs.getString("firstname"),
                        rs.getString("middlename"),
                        rs.getString("lastname"),
                        rs.getString("address"),
                        rs.getString("role"),
                        rs.getInt("hotel_id")
                );
            }
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }

    // insert employee
    public static void insertEmployee(String firstName, String middleName, String lastName,
                                      String address, String role, int hotelId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "INSERT INTO Employee (firstname, middlename, lastname, address, role, hotel_id) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, firstName);
            stmt.setString(2, middleName.isEmpty() ? null : middleName);
            stmt.setString(3, lastName);
            stmt.setString(4, address);
            stmt.setString(5, role);
            stmt.setInt(6, hotelId);
            stmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }
    // update employee
    public static void updateEmployee(int ssn, String firstName, String middleName, String lastName,
                                      String address, String role, int hotelId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "UPDATE Employee SET firstname=?, middlename=?, lastname=?, address=?, role=?, hotel_id=? WHERE ssn=?";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, firstName);
            stmt.setString(2, middleName.isEmpty() ? null : middleName);
            stmt.setString(3, lastName);
            stmt.setString(4, address);
            stmt.setString(5, role);
            stmt.setInt(6, hotelId);
            stmt.setInt(7, ssn);
            stmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // delete employeee
    public static void deleteEmployee(int ssn) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "DELETE FROM Employee WHERE ssn = ?";
        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, ssn);
            stmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }
}