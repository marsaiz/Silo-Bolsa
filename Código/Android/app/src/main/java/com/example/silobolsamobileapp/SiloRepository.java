package com.example.silobolsamobileapp;

import android.util.Log;

import com.google.gson.Gson;

import org.json.JSONException;

import java.io.IOException;

public class SiloRepository {
    public static Silo GetSiloById(String idSilo) throws IOException, JSONException {
        try {
            //Realizar la petición GET
            String urlString = "http://192.168.1.23:5006/api/silos/" + idSilo;
            String jsonRespuesta = NetwokUtils.realizarPeticionGET(urlString);

            //Parsear el JSON a un objeto Silo
            Gson gson = new Gson();
            return gson.fromJson(jsonRespuesta, Silo.class);
        } catch (Exception e) {
            //Registrar el error en el logcat
            Log.e("SiloRepository", "Error al obtener el silo: " + e.getMessage());
            throw e;
        }
    }

    public static Lectura GetLecturas() throws IOException, JSONException {
        String urlString = "http://192.168.1.23:5006/api/lecturas";
        String jsonRespuesta = NetwokUtils.realizarPeticionGET(urlString);
        Gson gson = new Gson();
        return gson.fromJson(jsonRespuesta, Lectura.class);
    }

}
