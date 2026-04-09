package com.demo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class Customer {

    private int cust_id;
    private String firstname;
    private String middlename;
    private String lastname;
    private String address;
    private Date registrationdate;
    private String username;
    private String password;

    public Customer(int cust_id, String firstname, String middlename, String lastname,String address,Date registrationdate,String username,String password){
        this.cust_id = cust_id;
        this.firstname = firstname;
        this.middlename = middlename;
        this.lastname = lastname;
        this.address = address;
        this.registrationdate = registrationdate;
        this.username = username;
        this.password = password;
    }
    public int getcustomerid() { return cust_id; }
    public String getFirstName() { return firstname; }
    public String getMiddleName() { return middlename; }
    public String getLastName() { return lastname; }
    public String getAddress() { return address; }
    public Date getRegistrationDate() { return registrationdate; }
    public String getUsername() { return username; }
    public String getPassword() { return password; }

    // =========================
    // get all customers
    // =========================
    public static List<Customer> getCustomers() throws Exception {
        List<Customer> customers = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT cust_id, firstname, middlename, lastname, address, registrationdate, username, password  FROM Customer";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                customers.add(new Customer(
                        rs.getInt("cust_id"),
                        rs.getString("firstname"),
                        rs.getString("middlename"),
                        rs.getString("lastname"),
                        rs.getString("address"),
                        rs.getDate("registrationdate"),
                        rs.getString("username"),
                        rs.getString("password")
                ));
            }
            if (customers.isEmpty()) {
                System.out.println("No Customers found in DB");
            } else {
                System.out.println("Customers loaded: " + customers.size());
            }
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return customers;
    }

    // =========================
    // get all customer by id
    // =========================
    public static Customer getCustomerById(int cust_id) throws Exception{
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT cust_id, firstname, middlename, lastname, address, registrationdate, username, password FROM Customer WHERE cust_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, cust_id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Customer(
                        rs.getInt("cust_id"),
                        rs.getString("firstname"),
                        rs.getString("middlename"),
                        rs.getString("lastname"),
                        rs.getString("address"),
                        rs.getDate("registrationdate"),
                        rs.getString("username"),
                        rs.getString("password")
                );
            }
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }

    // =========================
    // insert customer
    // =========================
    public static void insertCustomer(String firstname, String middlename, String lastname, String address, Date registrationdate,String username, String password ) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "INSERT INTO Customer (firstname, middlename, lastname, address, registrationdate, username, password) VALUES (?, ?, ?, ?, ?, ?,?)";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, firstname);
            stmt.setString(2, middlename);
            stmt.setString(3, lastname);
            stmt.setString(4, address);
            stmt.setDate(5, registrationdate);
            stmt.setString(6, username);
            stmt.setString(7, password);
            stmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }
    // =========================
    // update customer
    // =========================
    public static void updateCustomer(int cust_id, String firstname, String middlename, String lastname, String address, Date registrationdate,String username, String password ) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "UPDATE Customer SET firstname = ?, middlename = ?, lastname = ?, address = ?,registrationdate = ?,username = ?, password = ? WHERE cust_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, firstname);
            stmt.setString(2, middlename);
            stmt.setString(3, lastname);
            stmt.setString(4, address);
            stmt.setDate(5, registrationdate);
            stmt.setString(6, username);
            stmt.setString(7, password);
            stmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }
    // =========================
    // delete customer
    // =========================
    public static void deleteCustomer(int cust_id) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "DELETE FROM Customer WHERE cust_id = ?";
        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, cust_id);
            stmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }


}
