package com.example.silobolsamobileapp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.JSONException;
import org.json.JSONObject;

public class NetwokUtils {

    public static String realizarPeticionGET(String ulrString) throws IOException {
        URL url = new URL(ulrString);
        HttpURLConnection conexion = (HttpURLConnection) url.openConnection();
        conexion.setRequestMethod("GET");

        BufferedReader reader = new BufferedReader(new InputStreamReader(conexion.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();
        conexion.disconnect();

        return response.toString();
    }

    public static String realizarPeticionPOST(String urlString, double latitud, double longitud, String tipoGrano, int capacidad, String descripción) throws IOException, JSONException {
        URL url = new URL(urlString);
        HttpURLConnection conexion = (HttpURLConnection) url.openConnection();
        conexion.setRequestMethod("POST");
        conexion.setRequestProperty("Content-Type", "application/json; utf-8");
        conexion.setRequestProperty("Accept", "application/json");
        conexion.setDoOutput(true);

        //Crear objeto JSON con los datos que se van a enviar
        JSONObject json = new JSONObject();
        json.put("latitud", latitud);
        json.put("longitud", longitud);
        json.put("capacidad", capacidad);
        json.put("idGrano", tipoGrano);
        json.put("descripcion", descripción);

        try (OutputStream os = conexion.getOutputStream()) {
            byte[] input = json.toString().getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conexion.getInputStream(), "utf-8"))) {
            StringBuilder response = new StringBuilder();
            String responseLine = null;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            System.out.println(response.toString());
            return response.toString();
        }
    }
}