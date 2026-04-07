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

    public Hotel(int hotelId, String address, double rating, int chainId, int managerSsn) {
        this.hotelId = hotelId;
        this.address = address;
        this.rating = rating;
        this.chainId = chainId;
        this.managerSsn = managerSsn;
    }
    public int getHotelId() { return hotelId; }
    public String getAddress() { return address; }
    public double getRating() { return rating; }
    public int getChainId() { return chainId; }
    public int getManagerSsn() { return managerSsn; }

    // =========================
    // get all hotels
    // =========================
    public static List<Hotel> getHotels() throws Exception {
        List<Hotel> hotels = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT hotel_id, address, rating, chain_id, manager_ssn FROM Hotel";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                hotels.add(new Hotel(
                        rs.getInt("hotel_id"),
                        rs.getString("address"),
                        rs.getDouble("rating"),
                        rs.getInt("chain_id"),
                        rs.getInt("manager_ssn")
                ));
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
    // =========================
    // get hotel by id
    // =========================
    public static Hotel getHotelById(int hotelId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT hotel_id, address, rating, chain_id, manager_ssn FROM Hotel WHERE hotel_id = ?";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, hotelId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Hotel(
                        rs.getInt("hotel_id"),
                        rs.getString("address"),
                        rs.getDouble("rating"),
                        rs.getInt("chain_id"),
                        rs.getInt("manager_ssn")
                );
            }
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }
    // =========================
    // insert hotel
    // =========================
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
    // =========================
    // update hotel
    // =========================
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
    // =========================
    // delete
    // =========================
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
}