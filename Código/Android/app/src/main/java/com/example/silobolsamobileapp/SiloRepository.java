package com.example.silobolsamobileapp;

import android.content.Intent;
import android.util.Log;

import com.google.gson.Gson;

import org.json.JSONException;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class SiloRepository {
    public static Silo GetSiloById(String idSilo) throws IOException, JSONException {
        try {
            //Realizar la petición GET
            String urlString = "http://192.168.1.21:5006/api/silos/" + idSilo;
            //String urlString = "http://172.23.5.215:5006/api/silos/" + idSilo;
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
        String urlString = "http://192.168.1.21:5006/api/lecturas";
        //String urlString = "http://172.23.5.215:5006/api/lecturas/";
        String jsonRespuesta = NetwokUtils.realizarPeticionGET(urlString);
        Gson gson = new Gson();
        return gson.fromJson(jsonRespuesta, Lectura.class);
    }

    public LecturaContainer GetLecturasBySilo(String idSilo) throws IOException, JSONException {
        try {
            String urlString = "http://192.168.1.21:5006/api/lecturas/" + idSilo;
            //String urlString = "http://172.23.5.215:5006/api/lecturas/" + idSilo;
            String respuestaGet = NetwokUtils.realizarPeticionGET(urlString);
            Gson gson = new Gson();
            return gson.fromJson(respuestaGet, LecturaContainer.class);
        } catch (Exception e) {
            Log.e("SiloRepository", "Error al obtener las lecturas: " + e.getMessage());
            throw e;
        }
    }
}
