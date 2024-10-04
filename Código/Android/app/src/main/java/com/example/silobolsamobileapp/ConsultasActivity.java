package com.example.silobolsamobileapp;

import android.os.Bundle;

import android.os.StrictMode;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView  ;
import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import java.io.IOException;

public class ConsultasActivity extends AppCompatActivity {

    private TextView respuesta;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_consultas);

        //Necesario para permitir conexiones de red en el hilo principal (solo para este ejemplo)
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        respuesta = findViewById(R.id.silosConsultados);
        Button botonGET = findViewById(R.id.siloConsulta);

        botonGET.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    String respuestaGET = NetwokUtils.realizarPeticionGET("http://192.168.1.23:5006/api/silos");
                    Log.d("respuesta", respuestaGET);
                    respuesta.setText("respuesta: " + respuestaGET);
                }catch (IOException e){
                    Log.e("error", "Error al realizar la petición GET", e);
                    respuesta.setText("Error: " + e.getMessage());
                }
            }
        });
    }
}