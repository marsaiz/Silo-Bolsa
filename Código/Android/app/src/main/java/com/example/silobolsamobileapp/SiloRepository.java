package com.example.silobolsamobileapp;

import com.google.gson.Gson;

import org.json.JSONException;

import java.io.IOException;

public class SiloRepository {
    public static Silo GetSiloById (String idSilo) throws IOException, JSONException
    {
        // Construir la URL de la petición - código anterior
        //String url = "http://192.128.1.21:5006/api/silos/" + idSilo;

        //Realizar la petición GET
        String urlString = "http://192.168.1.23:5006/api/silos/";
        String jsonRespuesta = NetwokUtils.realizarPeticionGET(urlString);

        //Parsear el JSON a un objeto Silo
        Gson gson = new Gson();
        return gson.fromJson(jsonRespuesta, Silo.class);
    }

     /*public void actualizarUbicacion(double nuevaLatitud, double nuevaLongitud) {
        this.latitud = nuevaLatitud;
        this.longitud = nuevaLongitud;
        try {
            NetwokUtils.realizarPeticionPUT("http://192.168.1.23:5006/api/silos/" + this.idSilo, nuevaLatitud, nuevaLongitud);
        } catch (IOException | JSONException e) {
            // Manejar errores
        }
    }*/
    public static Lectura GetLecturas() throws IOException, JSONException {
        String urlString = "http://192.168.1.23:5006/api/lecturas";
    String jsonRespuesta = NetwokUtils.realizarPeticionGET(urlString);
    Gson gson = new Gson();
    return gson.fromJson(jsonRespuesta, Lectura.class);
    }

}
