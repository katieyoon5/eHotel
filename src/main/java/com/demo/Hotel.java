package com.demo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Hotel {

    public static List<String> getHotels() throws Exception {

        List<String> hotels = new ArrayList<>();
        ConnectionDB db = new ConnectionDB();

        String sql = "SELECT hotel_id, address, rating FROM Hotel";

        try (Connection con = db.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String hotel = rs.getInt("hotel_id") + " - "
                        + rs.getString("address") + " - "
                        + rs.getDouble("rating");

                hotels.add(hotel);
            }

            //  check if anything was found
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
}