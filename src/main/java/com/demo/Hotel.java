package com.demo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Hotel {

    private int hotelId;
    private String address;
    private double rating;
    private int chainId;
    private int managerSsn;
    private List<String> phones;
    private List<String> emails;

    public Hotel(int hotelId, String address, double rating, int chainId, int managerSsn) {
        this.hotelId = hotelId;
        this.address = address;
        this.rating = rating;
        this.chainId = chainId;
        this.managerSsn = managerSsn;
        this.phones = new ArrayList<>();
        this.emails = new ArrayList<>();
    }

    public int getHotelId() { return hotelId; }
    public String getAddress() { return address; }
    public double getRating() { return rating; }
    public int getChainId() { return chainId; }
    public int getManagerSsn() { return managerSsn; }
    public List<String> getPhones() { return phones; }
    public List<String> getEmails() { return emails; }

    // get all hotels
    public static List<Hotel> getHotels() throws Exception {
        List<Hotel> hotels = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT hotel_id, address, rating, chain_id, manager_ssn FROM Hotel";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Hotel h = new Hotel(
                        rs.getInt("hotel_id"),
                        rs.getString("address"),
                        rs.getDouble("rating"),
                        rs.getInt("chain_id"),
                        rs.getInt("manager_ssn")
                );
                h.phones = getPhonesForHotel(con, h.hotelId);
                h.emails = getEmailsForHotel(con, h.hotelId);
                hotels.add(h);
            }
            if (hotels.isEmpty()) {
                System.out.println("No hotels found in DB");
            } else {
                System.out.println("Hotels loaded: " + hotels.size());
            }
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return hotels;
    }

    // get hotel by id
    public static Hotel getHotelById(int hotelId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT hotel_id, address, rating, chain_id, manager_ssn FROM Hotel WHERE hotel_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, hotelId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Hotel h = new Hotel(
                        rs.getInt("hotel_id"),
                        rs.getString("address"),
                        rs.getDouble("rating"),
                        rs.getInt("chain_id"),
                        rs.getInt("manager_ssn")
                );
                h.phones = getPhonesForHotel(con, hotelId);
                h.emails = getEmailsForHotel(con, hotelId);
                return h;
            }
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }

    // get phones for hotel (with connection)
    public static List<String> getPhonesForHotel(Connection con, int hotelId) throws Exception {
        List<String> phones = new ArrayList<>();
        ConnectionDB db = null;
        boolean ownConnection = (con == null);
        if (ownConnection) {
            db = new ConnectionDB();
            con = db.getConnection();
        }
        String sql = "SELECT Phone FROM HotelPhone WHERE Hotel_ID = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, hotelId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) phones.add(rs.getString("Phone"));
        rs.close();
        stmt.close();
        if (ownConnection && db != null) db.close();
        return phones;
    }

    // get emails for hotel (with connection)
    public static List<String> getEmailsForHotel(Connection con, int hotelId) throws Exception {
        List<String> emails = new ArrayList<>();
        ConnectionDB db = null;
        boolean ownConnection = (con == null);
        if (ownConnection) {
            db = new ConnectionDB();
            con = db.getConnection();
        }
        String sql = "SELECT Email FROM HotelEmail WHERE Hotel_ID = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, hotelId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) emails.add(rs.getString("Email"));
        rs.close();
        stmt.close();
        if (ownConnection && db != null) db.close();
        return emails;
    }

    // get phones by hotel id (no connection needed)
    public static List<String> getPhonesByHotelId(int hotelId) throws Exception {
        return getPhonesForHotel(null, hotelId);
    }

    // get emails by hotel id (no connection needed)
    public static List<String> getEmailsByHotelId(int hotelId) throws Exception {
        return getEmailsForHotel(null, hotelId);
    }

    // insert hotel
    public static void insertHotel(String address, double rating, int chainId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "INSERT INTO Hotel (address, rating, chain_id) VALUES (?, ?, ?)";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, address);
            stmt.setDouble(2, rating);
            stmt.setInt(3, chainId);
            stmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // update hotel
    public static void updateHotel(int hotelId, String address, double rating, int chainId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "UPDATE Hotel SET address = ?, rating = ?, chain_id = ? WHERE hotel_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, address);
            stmt.setDouble(2, rating);
            stmt.setInt(3, chainId);
            stmt.setInt(4, hotelId);
            stmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // delete hotel
    public static void deleteHotel(int hotelId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "DELETE FROM Hotel WHERE hotel_id = ?";
        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, hotelId);
            stmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // add phone
    public static void addPhone(int hotelId, String phone) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "INSERT INTO HotelPhone (Hotel_ID, Phone) VALUES (?, ?)";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, hotelId);
            stmt.setString(2, phone);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // delete phone
    public static void deletePhone(int hotelId, String phone) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "DELETE FROM HotelPhone WHERE Hotel_ID = ? AND Phone = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, hotelId);
            stmt.setString(2, phone);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // add email
    public static void addEmail(int hotelId, String email) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "INSERT INTO HotelEmail (Hotel_ID, Email) VALUES (?, ?)";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, hotelId);
            stmt.setString(2, email);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // delete email
    public static void deleteEmail(int hotelId, String email) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "DELETE FROM HotelEmail WHERE Hotel_ID = ? AND Email = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, hotelId);
            stmt.setString(2, email);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }
}