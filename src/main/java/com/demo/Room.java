package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Room {
    private int hotel_id;
    private int chain_id;
    private int roomNumber;
    private float price;
    private int capacity;
    private String view;
    private Boolean extendable;

    public String hotelAddress;
    public String chainAddress;
    public float rating;

    public Room(int hotel_id, int chain_id, int roomNumber, float price, int capacity, String view, Boolean extendable){
        this.hotel_id = hotel_id;
        this.chain_id = chain_id;
        this.roomNumber = roomNumber;
        this.price = price;
        this.capacity = capacity;
        this.view = view;
        this.extendable = extendable;
    }
    public int getHotelId() { return hotel_id; }
    public int getChainId() { return chain_id; }
    public int getRoomNumber() { return roomNumber; }
    public float getPrice() { return price; }
    public int getCapacity() { return capacity; }
    public String getView() { return view; }
    public Boolean getExtendable() { return extendable; }

    public String getHotelAddress() { return hotelAddress; }
    public String getChainAddress() { return chainAddress; }
    public float getHotelRating() { return rating; }
    // =========================
    // get all rooms
    // =========================
    public static List<Room> getRooms(String sortBy) throws Exception {
        List<Room> rooms = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();

        String orderBy;

        if ("price".equals(sortBy)) {
            orderBy = "r.Price";
        } else if ("capacity".equals(sortBy)) {
            orderBy = "r.Capacity DESC";
        } else if ("chain".equals(sortBy)) {
            orderBy = "hc.Office_Address";
        } else if ("rating".equals(sortBy)) {
            orderBy = "h.Rating DESC";
        } else if ("area".equals(sortBy)) {
            orderBy = "h.Address";
        } else {
            orderBy = "r.Price";
        }

        String sql = """
        SELECT r.*,
               h.Address AS hotelAddress,
               h.Rating AS rating,
               hc.Office_Address AS chainAddress
        FROM Room r
        JOIN Hotel h ON r.Hotel_ID = h.Hotel_ID
        JOIN Hotel_Chain hc ON h.Chain_ID = hc.Chain_ID
        ORDER BY %s
    """.formatted(orderBy);

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Room r = new Room(
                        rs.getInt("Hotel_ID"),
                        rs.getInt("Chain_ID"),
                        rs.getInt("RoomNumber"),
                        rs.getFloat("Price"),
                        rs.getInt("Capacity"),
                        rs.getString("View"),
                        rs.getBoolean("Extendable")
                );

                r.hotelAddress = rs.getString("hotelAddress");
                r.chainAddress = rs.getString("chainAddress");
                r.rating = rs.getFloat("rating");

                rooms.add(r);
            }

        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }

        return rooms;
    }
    // =========================
    // get room by hotel id and room number
    // =========================
    public static Room getRoomByHotelAndNumber(int hotel_id, int roomNumber) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT * FROM Room WHERE Hotel_ID = ? AND RoomNumber = ?";
        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, hotel_id);
            stmt.setInt(2, roomNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Room(
                        rs.getInt("Hotel_ID"),
                        rs.getInt("Chain_ID"),
                        rs.getInt("RoomNumber"),
                        rs.getFloat("Price"),
                        rs.getInt("Capacity"),
                        rs.getString("View"),
                        rs.getBoolean("Extendable")
                );
            }
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }

    // =========================
    // get all booked dates
    // =========================
    public static List<String> getBlockedDates(int hotelId, int roomNumber) throws Exception {

        List<String> blocked = new ArrayList<>();

        ConnectionDB db = new ConnectionDB();
        Connection con = db.getConnection();

        // BLOCK BOOKED DATES
        String sql = """
            SELECT StartDate, EndDate
            FROM Booking
            WHERE Hotel_ID = ? AND RoomNumber = ?
        """;

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, hotelId);
        ps.setInt(2, roomNumber);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            LocalDate start = rs.getDate("StartDate").toLocalDate();
            LocalDate end = rs.getDate("EndDate").toLocalDate();

            while (!start.isAfter(end)) {
                blocked.add(start.toString());
                start = start.plusDays(1);
            }
        }

        rs.close();
        ps.close();

        // BLOCK PAST DATES
        LocalDate today = LocalDate.now();
        LocalDate start = LocalDate.of(2000, 1, 1); // or today.minusYears(1)

        while (start.isBefore(today)) {
            blocked.add(start.toString());
            start = start.plusDays(1);
        }

        return blocked;
    }
}

