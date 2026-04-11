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
    public float getRating() { return rating; }
    // =========================
    // get all rooms
    // =========================
    public static List<Room> getRooms(String sortBy) throws Exception {
        List<Room> rooms = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();

        String orderBy;

        switch (sortBy == null ? "price" : sortBy) {
            case "price":
                orderBy = "r.Price ASC";
                break;
            case "capacity":
                orderBy = "r.Capacity ASC";
                break;
            case "chain":
                orderBy = "hc.Office_Address ASC";
                break;
            case "rating":
                orderBy = "h.Rating DESC";
                break;
            case "area":
                orderBy = "h.Address ASC";
                break;
            default:
                orderBy = "r.Price ASC";
        }

        String sql =
                "SELECT r.*, " +
                "h.Address AS hotelAddress, " +
                "h.Rating AS rating, " +
                "hc.Office_Address AS chainAddress " +
                "FROM Room r " +
                "JOIN Hotel h ON r.Hotel_ID = h.Hotel_ID " +
                "JOIN Hotel_Chain hc ON h.Chain_ID = hc.Chain_ID " +
                "ORDER BY " + orderBy;
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

    public static List<Room> searchRooms(String hotelSearch, String chainSearch,
                                         String minPrice, String maxPrice,
                                         String capacity) throws Exception {

        List<Room> rooms = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();

        StringBuilder sql = new StringBuilder("""
            SELECT r.*,
                   h.Address AS hotelAddress,
                   h.Rating AS rating,
                   hc.Office_Address AS chainAddress
            FROM Room r
            JOIN Hotel h ON r.Hotel_ID = h.Hotel_ID
            JOIN Hotel_Chain hc ON h.Chain_ID = hc.Chain_ID
            WHERE 1=1
    """);

        List<Object> params = new ArrayList<>();

        if (hotelSearch != null && !hotelSearch.isEmpty()) {
            sql.append(" AND LOWER(h.Address) LIKE ?");
            params.add("%" + hotelSearch.toLowerCase() + "%");
        }

        if (chainSearch != null && !chainSearch.isEmpty()) {
            sql.append(" AND LOWER(hc.Office_Address) LIKE ?");
            params.add("%" + chainSearch.toLowerCase() + "%");
        }

        if (minPrice != null && !minPrice.isEmpty()) {
            sql.append(" AND r.Price >= ?");
            params.add(Float.parseFloat(minPrice));
        }

        if (maxPrice != null && !maxPrice.isEmpty()) {
            sql.append(" AND r.Price <= ?");
            params.add(Float.parseFloat(maxPrice));
        }

        if (capacity != null && !capacity.isEmpty()) {
            sql.append(" AND r.Capacity >= ?");
            params.add(Integer.parseInt(capacity));
        }

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql.toString())) {

            // set parameters safely
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();

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
        }

        return rooms;
    }


    //get amenities
    public static List<String> getAmenities(int hotelId, int roomNumber) throws Exception {
        List<String> list = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();

        String sql = "SELECT Amenity FROM RoomAmenities WHERE Hotel_ID=? AND RoomNumber=?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, hotelId);
            ps.setInt(2, roomNumber);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("Amenity"));
            }
        }

        return list;
    }


    //get issues
    public static List<String> getIssues(int hotelId, int roomNumber) throws Exception {
        List<String> list = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();

        String sql = "SELECT Issue FROM RoomIssues WHERE Hotel_ID=? AND RoomNumber=?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, hotelId);
            ps.setInt(2, roomNumber);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("Issue"));
            }
        }

        return list;
    }
    // =========================
    // get room by hotel id and room number
    // =========================
    public static Room getRoomByHotelAndNumber(int hotel_id, int roomNumber) throws Exception {

        ConnectionDB db = new ConnectionDB();

        String sql = """
        SELECT r.*,
               h.Address AS hotelAddress,
               hc.Office_Address AS chainAddress
        FROM Room r
        JOIN Hotel h ON r.Hotel_ID = h.Hotel_ID
        JOIN Hotel_Chain hc ON h.Chain_ID = hc.Chain_ID
        WHERE r.Hotel_ID = ? AND r.RoomNumber = ?
    """;

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, hotel_id);
            stmt.setInt(2, roomNumber);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
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

                return r;
            }
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

    // get all rooms (for manage page)
    public static List<Room> getAllRooms() throws Exception {
        List<Room> rooms = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT r.*, h.Address AS hotelAddress, h.Rating AS rating, hc.Office_Address AS chainAddress " +
                "FROM Room r JOIN Hotel h ON r.Hotel_ID = h.Hotel_ID JOIN Hotel_Chain hc ON h.Chain_ID = hc.Chain_ID";

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

    // get available rooms (for direct renting)
    public static List<Room> getAvailableRooms() throws Exception {
        List<Room> rooms = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();
        String sql = """
        SELECT r.*, h.Address AS hotelAddress, h.Rating AS rating, hc.Office_Address AS chainAddress
        FROM Room r
        JOIN Hotel h ON r.Hotel_ID = h.Hotel_ID
        JOIN Hotel_Chain hc ON h.Chain_ID = hc.Chain_ID
        WHERE NOT EXISTS (
            SELECT 1 FROM Renting rt
            WHERE rt.Hotel_ID = r.Hotel_ID AND rt.RoomNumber = r.RoomNumber
        )
    """;

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

    // get room by id (for edit form)
    public static Room getRoomById(int hotelId, int roomNumber) throws Exception {
        return getRoomByHotelAndNumber(hotelId, roomNumber);
    }

    // insert room
    public static void insertRoom(int hotelId, int chainId, int roomNumber,
                                  float price, int capacity, String view, boolean extendable) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "INSERT INTO Room (Hotel_ID, Chain_ID, RoomNumber, Price, Capacity, View, Extendable) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, hotelId);
            stmt.setInt(2, chainId);
            stmt.setInt(3, roomNumber);
            stmt.setFloat(4, price);
            stmt.setInt(5, capacity);
            stmt.setString(6, view);
            stmt.setBoolean(7, extendable);
            stmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // update room
    public static void updateRoom(int hotelId, int roomNumber, float price, int capacity,
                                  String view, boolean extendable) throws Exception {
        ConnectionDB db = new ConnectionDB();
        String sql = "UPDATE Room SET Price=?, Capacity=?, View=?, Extendable=? WHERE Hotel_ID=? AND RoomNumber=?";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setFloat(1, price);
            stmt.setInt(2, capacity);
            stmt.setString(3, view);
            stmt.setBoolean(4, extendable);
            stmt.setInt(5, hotelId);
            stmt.setInt(6, roomNumber);
            stmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // delete room
    public static void deleteRoom(int hotelId, int roomNumber) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {

            // delete amenities first
            String deleteAmenities = "DELETE FROM RoomAmenities WHERE Hotel_ID = ? AND RoomNumber = ?";
            PreparedStatement ps1 = con.prepareStatement(deleteAmenities);
            ps1.setInt(1, hotelId);
            ps1.setInt(2, roomNumber);
            ps1.executeUpdate();
            ps1.close();

            // delete issues
            String deleteIssues = "DELETE FROM RoomIssues WHERE Hotel_ID = ? AND RoomNumber = ?";
            PreparedStatement ps2 = con.prepareStatement(deleteIssues);
            ps2.setInt(1, hotelId);
            ps2.setInt(2, roomNumber);
            ps2.executeUpdate();
            ps2.close();

            // delete payments linked to rentings of this room
            String deletePayments = """
            DELETE FROM Payment WHERE Rent_ID IN (
                SELECT Rent_ID FROM Renting WHERE Hotel_ID = ? AND RoomNumber = ?
            )
        """;
            PreparedStatement ps3 = con.prepareStatement(deletePayments);
            ps3.setInt(1, hotelId);
            ps3.setInt(2, roomNumber);
            ps3.executeUpdate();
            ps3.close();

            // delete rentings
            String deleteRentings = "DELETE FROM Renting WHERE Hotel_ID = ? AND RoomNumber = ?";
            PreparedStatement ps4 = con.prepareStatement(deleteRentings);
            ps4.setInt(1, hotelId);
            ps4.setInt(2, roomNumber);
            ps4.executeUpdate();
            ps4.close();

            // delete bookings
            String deleteBookings = "DELETE FROM Booking WHERE Hotel_ID = ? AND RoomNumber = ?";
            PreparedStatement ps5 = con.prepareStatement(deleteBookings);
            ps5.setInt(1, hotelId);
            ps5.setInt(2, roomNumber);
            ps5.executeUpdate();
            ps5.close();

            // now delete the room
            String sql = "DELETE FROM Room WHERE Hotel_ID = ? AND RoomNumber = ?";
            PreparedStatement ps6 = con.prepareStatement(sql);
            ps6.setInt(1, hotelId);
            ps6.setInt(2, roomNumber);
            ps6.executeUpdate();
            ps6.close();

        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }
    // get amenities for room
    public static List<String> getAmenitiesForRoom(int hotelId, int roomNumber) throws Exception {
        List<String> amenities = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "SELECT Amenity FROM RoomAmenities WHERE Hotel_ID = ? AND RoomNumber = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, hotelId);
            stmt.setInt(2, roomNumber);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) amenities.add(rs.getString("Amenity"));
            rs.close();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return amenities;
    }

    // add amenity to room
    public static void addAmenity(int hotelId, int roomNumber, String amenity) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "INSERT INTO RoomAmenities (Hotel_ID, RoomNumber, Amenity) VALUES (?, ?, ?)";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, hotelId);
            stmt.setInt(2, roomNumber);
            stmt.setString(3, amenity);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }


    // delete amenity from room
    public static void deleteAmenity(int hotelId, int roomNumber, String amenity) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "DELETE FROM RoomAmenities WHERE Hotel_ID = ? AND RoomNumber = ? AND Amenity = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, hotelId);
            stmt.setInt(2, roomNumber);
            stmt.setString(3, amenity);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // get issues for room
    public static List<String> getIssuesForRoom(int hotelId, int roomNumber) throws Exception {
        List<String> issues = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "SELECT Issue FROM RoomIssues WHERE Hotel_ID = ? AND RoomNumber = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, hotelId);
            stmt.setInt(2, roomNumber);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) issues.add(rs.getString("Issue"));
            rs.close();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return issues;
    }

    // add issue to room
    public static void addIssue(int hotelId, int roomNumber, String issue) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "INSERT INTO RoomIssues (Hotel_ID, RoomNumber, Issue) VALUES (?, ?, ?)";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, hotelId);
            stmt.setInt(2, roomNumber);
            stmt.setString(3, issue);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }

    // delete issue from room
    public static void deleteIssue(int hotelId, int roomNumber, String issue) throws Exception {
        ConnectionDB db = new ConnectionDB();
        try (Connection con = db.getConnection()) {
            String sql = "DELETE FROM RoomIssues WHERE Hotel_ID = ? AND RoomNumber = ? AND Issue = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, hotelId);
            stmt.setInt(2, roomNumber);
            stmt.setString(3, issue);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
    }
}

