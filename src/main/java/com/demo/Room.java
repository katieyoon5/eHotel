package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Room {
    private int hotel_id;
    private int chain_id;
    private Boolean available;
    private int roomNumber;
    private float price;
    private int capacity;
    private String view;
    private Boolean extendable;

    public Room(int hotel_id, int chain_id, Boolean available, int roomNumber, float price, int capacity, String view, Boolean extendable){
        this.hotel_id = hotel_id;
        this.chain_id = chain_id;
        this.available = available;
        this.roomNumber = roomNumber;
        this.price = price;
        this.capacity = capacity;
        this.view = view;
        this.extendable = extendable;
    }
    public int getHotelId() { return hotel_id; }
    public int getChainId() { return chain_id; }
    public Boolean getAvailable() { return available; }
    public int getRoomNumber() { return roomNumber; }
    public float getPrice() { return price; }
    public int getCapacity() { return capacity; }
    public String getView() { return view; }
    public Boolean getExtendable() { return extendable; }

    // =========================
    // get only available rooms
    // =========================
    public static List<Room> getAvailableRooms() throws Exception {
        List<Room> rooms = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();
        String sql = "SELECT Hotel_ID, Chain_ID, Available, RoomNumber, Price, Capacity, View, Extendable " +
                "FROM ROOM WHERE Available = TRUE";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                rooms.add(new Room(
                        rs.getInt("Hotel_ID"),
                        rs.getInt("Chain_ID"),
                        rs.getBoolean("Available"),
                        rs.getInt("RoomNumber"),
                        rs.getFloat("Price"),
                        rs.getInt("Capacity"),
                        rs.getString("View"),
                        rs.getBoolean("Extendable")
                ));
            }
            if (rooms.isEmpty()) {
                System.out.println("No rooms found in DB");
            } else {
                System.out.println("rooms loaded: " + rooms.size());
            }
        } catch (Exception e) {
            System.out.println("DB ERROR: " + e.getMessage());
            throw e;
        }
        return rooms;
    }


}

