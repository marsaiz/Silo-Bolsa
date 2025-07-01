package com.example.silobolsamobileapp;

import java.io.Serializable;

public class Alerta implements Serializable {
    public String idAlerta;
    public String fechaHoraAlerta;
    public String mensaje;
    public String idSilo;

    public Alerta(String idAlerta, String fechaHoraAlerta, String mensaje, String idSilo) {
        this.idAlerta = idAlerta;
        this.fechaHoraAlerta = fechaHoraAlerta;
        this.mensaje = mensaje;
        this.idSilo = idSilo;
    }

    public String getIdAlerta() {
        return idAlerta;
    }

    public void setIdAlerta(String idAlerta) {
        this.idAlerta = idAlerta;
    }

    public String getFechaHoraAlerta() {
        return fechaHoraAlerta;
    }

    public void setFechaHoraAlerta(String fechaHoraAlerta) {
        this.fechaHoraAlerta = fechaHoraAlerta;
    }
    public String getMensaje() {
        return mensaje;
    }
    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
    public String getidSilo() {return idSilo;}
    public void setidSilo(String idSilo) {this.idSilo = idSilo;}
}