package com.demo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HotelChain {

    private int chainId;
    private String officeAddress;
    private int numHotels;
    private List<String> phones;
    private List<String> emails;

    public HotelChain(int chainId, String officeAddress, int numHotels,
                      List<String> phones, List<String> emails) {
        this.chainId = chainId;
        this.officeAddress = officeAddress;
        this.numHotels = numHotels;
        this.phones = phones;
        this.emails = emails;
    }

    public int getChainId() { return chainId; }
    public String getOfficeAddress() { return officeAddress; }
    public int getNumHotels() { return numHotels; }
    public List<String> getPhones() { return phones; }
    public List<String> getEmails() { return emails; }

    // get all chains
    public static List<HotelChain> getAllChains() throws Exception {
        List<HotelChain> chains = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();

        try (Connection con = db.getConnection()) {
            String sql = "SELECT * FROM Hotel_Chain ORDER BY Chain_ID";
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int chainId = rs.getInt("Chain_ID");
                String officeAddress = rs.getString("Office_Address");
                int numHotels = rs.getInt("Num_Hotels");

                List<String> phones = getPhonesForChain(con, chainId);
                List<String> emails = getEmailsForChain(con, chainId);

                chains.add(new HotelChain(chainId, officeAddress, numHotels, phones, emails));
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return chains;
    }

    // get chain by id
    public static HotelChain getChainById(int chainId) throws Exception {
        ConnectionDB db = new ConnectionDB();

        try (Connection con = db.getConnection()) {
            String sql = "SELECT * FROM Hotel_Chain WHERE Chain_ID = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, chainId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                List<String> phones = getPhonesForChain(con, chainId);
                List<String> emails = getEmailsForChain(con, chainId);
                return new HotelChain(
                        rs.getInt("Chain_ID"),
                        rs.getString("Office_Address"),
                        rs.getInt("Num_Hotels"),
                        phones, emails
                );
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }

    // get phones for chain
    private static List<String> getPhonesForChain(Connection con, int chainId) throws Exception {
        List<String> phones = new ArrayList<>();
        String sql = "SELECT Phone FROM HotelChainPhone WHERE Chain_ID = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, chainId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) phones.add(rs.getString("Phone"));
        rs.close();
        stmt.close();
        return phones;
    }

    // get emails for chain
    private static List<String> getEmailsForChain(Connection con, int chainId) throws Exception {
        List<String> emails = new ArrayList<>();
        String sql = "SELECT Email FROM HotelChainEmail WHERE Chain_ID = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, chainId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) emails.add(rs.getString("Email"));
        rs.close();
        stmt.close();
        return emails;
    }

    // insert chain
    public static int insertChain(String officeAddress, int numHotels) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "INSERT INTO Hotel_Chain (Office_Address, Num_Hotels) VALUES (?, ?) RETURNING Chain_ID";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, officeAddress);
            stmt.setInt(2, numHotels);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
            rs.close();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return -1;
    }

    // update chain
    public static void updateChain(int chainId, String officeAddress, int numHotels) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "UPDATE Hotel_Chain SET Office_Address=?, Num_Hotels=? WHERE Chain_ID=?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, officeAddress);
            stmt.setInt(2, numHotels);
            stmt.setInt(3, chainId);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // delete chain
    public static void deleteChain(int chainId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "DELETE FROM Hotel_Chain WHERE Chain_ID=?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, chainId);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // add phone
    public static void addPhone(int chainId, String phone) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "INSERT INTO HotelChainPhone (Chain_ID, Phone) VALUES (?, ?)";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, chainId);
            stmt.setString(2, phone);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // delete phone
    public static void deletePhone(int chainId, String phone) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "DELETE FROM HotelChainPhone WHERE Chain_ID=? AND Phone=?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, chainId);
            stmt.setString(2, phone);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // add email
    public static void addEmail(int chainId, String email) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "INSERT INTO HotelChainEmail (Chain_ID, Email) VALUES (?, ?)";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, chainId);
            stmt.setString(2, email);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }
    // delete email
    public static void deleteEmail(int chainId, String email) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "DELETE FROM HotelChainEmail WHERE Chain_ID=? AND Email=?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, chainId);
            stmt.setString(2, email);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }
}