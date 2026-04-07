package com.demo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Booking {
    public int bookId;
    public String startDate;
    public String endDate;
    public int hotelId;
    public int roomNumber;
    public int custId;
    public String customerName;

    // =========================
    // get all the bookings
    // =========================
    public static List<Booking> getAllBookings() throws Exception {
        List<Booking> bookings = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();
        try {
            Connection con = db.getConnection();
            String sql = """
                SELECT b.*, c.FirstName, c.LastName
                FROM Booking b
                JOIN Customer c ON b.Cust_ID = c.Cust_ID
                ORDER BY b.StartDate
            """;
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.bookId = rs.getInt("Book_ID");
                b.startDate = rs.getString("StartDate");
                b.endDate = rs.getString("EndDate");
                b.hotelId = rs.getInt("Hotel_ID");
                b.roomNumber = rs.getInt("RoomNumber");
                b.custId = rs.getInt("Cust_ID");
                b.customerName = rs.getString("FirstName") + " " + rs.getString("LastName");
                bookings.add(b);
            }
            rs.close();
            ps.close();
        } finally {
            db.close();
        }
        return bookings;
    }
    // =========================
    // get booking id
    // =========================
    public static Booking getBookingById(int bookId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try {
            Connection con = db.getConnection();
            String sql = """
                SELECT b.*, c.FirstName, c.LastName
                FROM Booking b
                JOIN Customer c ON b.Cust_ID = c.Cust_ID
                WHERE b.Book_ID = ?
            """;
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Booking b = new Booking();
                b.bookId = rs.getInt("Book_ID");
                b.startDate = rs.getString("StartDate");
                b.endDate = rs.getString("EndDate");
                b.hotelId = rs.getInt("Hotel_ID");
                b.roomNumber = rs.getInt("RoomNumber");
                b.custId = rs.getInt("Cust_ID");
                b.customerName = rs.getString("FirstName") + " " + rs.getString("LastName");
                rs.close();
                ps.close();
                return b;
            }
            rs.close();
            ps.close();
        } finally {
            db.close();
        }
        return null;
    }
    // =========================
    // booking to renting
    // =========================
    public static void convertToRenting(int bookId, int employeeSSN) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try {
            Connection con = db.getConnection();

            String getSql = "SELECT * FROM Booking WHERE Book_ID = ?";
            PreparedStatement getPs = con.prepareStatement(getSql);
            getPs.setInt(1, bookId);
            ResultSet rs = getPs.executeQuery();

            if (rs.next()) {
                Date startDate = rs.getDate("StartDate");
                Date endDate = rs.getDate("EndDate");
                int hotelId = rs.getInt("Hotel_ID");
                int roomNumber = rs.getInt("RoomNumber");
                int custId = rs.getInt("Cust_ID");

                String insertSql = """
                    INSERT INTO Renting (Start_Date, End_Date, Hotel_ID, RoomNumber, Cust_ID, SSN)
                    VALUES (?, ?, ?, ?, ?, ?)
                """;
                PreparedStatement insertPs = con.prepareStatement(insertSql);
                insertPs.setDate(1, startDate);
                insertPs.setDate(2, endDate);
                insertPs.setInt(3, hotelId);
                insertPs.setInt(4, roomNumber);
                insertPs.setInt(5, custId);
                insertPs.setInt(6, employeeSSN);
                insertPs.executeUpdate();
                insertPs.close();

                String deleteSql = "DELETE FROM Booking WHERE Book_ID = ?";
                PreparedStatement deletePs = con.prepareStatement(deleteSql);
                deletePs.setInt(1, bookId);
                deletePs.executeUpdate();
                deletePs.close();
            }
            rs.close();
            getPs.close();

        } finally {
            db.close();
        }
    }
    // =========================
    // insert bookinh
    // =========================
    public static void insertBooking(String startDate, String endDate,
                                     int hotelId, int roomNumber, int custId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try {
            Connection con = db.getConnection();
            String sql = """
                INSERT INTO Booking (StartDate, EndDate, Hotel_ID, RoomNumber, Cust_ID)
                VALUES (?, ?, ?, ?, ?)
            """;
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, Date.valueOf(startDate));
            ps.setDate(2, Date.valueOf(endDate));
            ps.setInt(3, hotelId);
            ps.setInt(4, roomNumber);
            ps.setInt(5, custId);
            ps.executeUpdate();
            ps.close();
        } finally {
            db.close();
        }
    }
    // =========================
    // delete booking
    // =========================
    public static void deleteBooking(int bookId) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try {
            Connection con = db.getConnection();
            String sql = "DELETE FROM Booking WHERE Book_ID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookId);
            ps.executeUpdate();
            ps.close();
        } finally {
            db.close();
        }
    }
}