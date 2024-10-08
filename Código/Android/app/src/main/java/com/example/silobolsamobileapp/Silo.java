package com.example.silobolsamobileapp;

public class Silo {
    public String idSilo;
    public double latitud;
    public double longitud;
    public int capacidad;
    public String tipoGrano;
    public String descripcion;

    public Silo(String idSilo, double latitud, double longitud, int capacidad, String tipoGrano, String descripcion) {
        this.idSilo = idSilo;
        this.latitud = latitud;
        this.longitud = longitud;
        this.capacidad = capacidad;
        this.tipoGrano = tipoGrano;
    }

    public String getIdSilo() {
        return idSilo;
    }

    public void setIdSilo(String idSilo) {
        this.idSilo = idSilo;
    }

    public double getLatitud() {
        return latitud;
    }

    public void setLatitud(double latitud) {
        this.latitud = latitud;
    }

    public double getLongitud() {
        return longitud;
    }

    public void setLongitud(double longitud) {
        this.longitud = longitud;
    }

    public int getCapacidad() {
        return capacidad;
    }

    public void setCapacidad(int capacidad) {
        this.capacidad = capacidad;
    }

    public String getTipoGrano() {
        return tipoGrano;
    }

    public void setTipoGrano(String tipoGrano) {
        this.tipoGrano = tipoGrano;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
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
}

