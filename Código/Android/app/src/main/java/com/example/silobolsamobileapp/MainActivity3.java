package com.example.silobolsamobileapp;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.TextView;
import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity3 extends AppCompatActivity {
    int CODIGO_SOLICITADO_MAPA = 1;
    TextView longitudTextView;
    TextView latitudTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main3);

        //Inicializar los TextView
        latitudTextView = findViewById(R.id.latitud);
        longitudTextView = findViewById(R.id.longitud);

        Button irAMapa = findViewById(R.id.buscarEnMapa);

        irAMapa.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity3.this, Mapa.class);
                startActivityForResult(intent, CODIGO_SOLICITADO_MAPA);
            }
        });

        String[] granos = new String[]{"Trigo", "Maíz", "Girasol", "Soja", "Arroz", "Cebada"};
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, granos);

        AutoCompleteTextView autoCompleteTextView = findViewById(R.id.TipoGrano);
        autoCompleteTextView.setAdapter(adapter);

        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        Button btnIrAtras = findViewById(R.id.volverAtras);
        btnIrAtras.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity3.this, MainActivity2.class);
                startActivity(intent);
                finish();
            }
        });

    }
//Verificar si la Activity fue finalizada correctamente y obtener los datos
    @Override
    protected void onActivityResult(int reqquestCode, int resultCode, Intent
            data) {
        super.onActivityResult(reqquestCode, resultCode, data);

        if (reqquestCode == CODIGO_SOLICITADO_MAPA && resultCode == Activity.RESULT_OK) {

            double latitud = data.getDoubleExtra("latitud", 0.0);
            double longitud = data.getDoubleExtra("longitud", 0.0);

            latitudTextView.setText(String.valueOf(latitud));
            longitudTextView.setText(String.valueOf(longitud));
        } else {
            latitudTextView.setText("Coordenadas no disponibles");
            longitudTextView.setText("Coordenadas no disponibles");
        }
    }
}