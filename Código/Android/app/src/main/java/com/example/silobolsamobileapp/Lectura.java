package com.example.silobolsamobileapp;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;
import java.io.Serializable;


public class Lectura implements Serializable {


    public String idLectura;

    public String idCaja;

    public String fechaHoraLectura;

    public double temp;

    public double humedad;

    public double dioxidoDeCarbono;


    public Lectura(String idLectura, String fechaHoraLectura, double temp, double humedad, double getDioxidoDeCarbono, String idCaja) {
        this.idLectura = idLectura;
        this.fechaHoraLectura = fechaHoraLectura;
        this.temp = temp;
        this.humedad = humedad;
        this.dioxidoDeCarbono = getDioxidoDeCarbono;
        this.idCaja = idCaja;
    }

    public String getIdLectura() {
        return idLectura;
    }

    public void setIdLectura(String idLectura) {
        this.idLectura = idLectura;
    }

    public String getFechaHoraLectura() {
        return fechaHoraLectura;
    }

    public void setFechaHoraLectura(String fechaHoraLectura) {
        this.fechaHoraLectura = fechaHoraLectura;
    }

    public Double getTemp() {
        return temp;
    }

    public void setTemp(double temp) {
        this.temp = temp;
    }

    public Double getHumedad() {
        return humedad;
    }

    public void setHumedad(double humedad) {
        this.humedad = humedad;
    }

    public Double getDioxidoDeCarbono() {
        return dioxidoDeCarbono;
    }

    public void setDioxidoDeCarbono(double dioxidoDeCarbono) {
        this.dioxidoDeCarbono = dioxidoDeCarbono;
    }

    public String getIdCaja() {
        return idCaja;
    }

    public void setIdCaja(String idDeCaja) {
        this.idCaja = idDeCaja;
    }

}
