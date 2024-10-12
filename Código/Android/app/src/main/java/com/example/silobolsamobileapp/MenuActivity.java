package com.example.silobolsamobileapp;

import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.view.View;
import android.widget.Button;
import android.content.pm.ActivityInfo;

public class MenuActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main2);

        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        Button btnIrPantallaIngresos = findViewById(R.id.newSilo);
        btnIrPantallaIngresos.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MenuActivity.this, IngresoSilo.class);
                startActivity(intent);
            }
        });

        Button btnIrPantallaConsultas = findViewById(R.id.consultas);
        btnIrPantallaConsultas.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MenuActivity.this, ConsultasActivity.class);
                startActivity(intent);
            }
        });

    }
}