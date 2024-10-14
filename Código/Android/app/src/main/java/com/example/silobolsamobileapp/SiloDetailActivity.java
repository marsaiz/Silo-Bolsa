package com.example.silobolsamobileapp;

import android.os.Bundle;
import android.text.InputType;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.RecyclerView;

public class SiloDetailActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_silo_detail);
        //Obtener el objeto Silo del Intent
       Silo silo = (Silo) getIntent().getSerializableExtra("silo");

       //Mostrar los datos del silo en los Textiews
        TextView idSiloTextView = findViewById(R.id.idSiloTextView);
        idSiloTextView.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
        TextView latitudTextView = findViewById(R.id.latitudTextView);
        TextView longitudTextView = findViewById(R.id.longitudTextView);
        TextView capacidadTextView = findViewById(R.id.capacidadTextView);
        TextView tipoGranoTextView = findViewById(R.id.tipoGranoTextView);
        TextView descripcionTextView = findViewById(R.id.descripcionTextView);

        //Asignar los valores del objeto Silo a los Textiews
        if (silo != null) {
            idSiloTextView.setText("ID Silo: " + silo.getIdSilo());
            latitudTextView.setText("Latitud: " + silo.getLatitud());
            longitudTextView.setText("Longitud: " + silo.getLongitud());
            capacidadTextView.setText("Capacidad: " + silo.getCapacidad());
            tipoGranoTextView.setText("Tipo de Grano: " + silo.getTipoGrano());
            descripcionTextView.setText("Descripción: " + silo.getDescripcion());
        } else {
            idSiloTextView.setText("No se encontraron datos del silo.");
        }

    }
}