package com.example.silobolsamobileapp;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class LecturasListActivity extends AppCompatActivity {
    private RecyclerView recyclerView;
    private LecturaAdapter adapter;
    private List<Lectura> listaLecturas;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_lecturas_list);

        recyclerView = findViewById(R.id.lecturasRecyclerView);
        listaLecturas = new ArrayList<>();

        // 1. Get JSON data from Intent
        String jsonString = getIntent().getStringExtra("json_lecturas");
        String jsonLecturasPorSilo = getIntent().getStringExtra("json_lecturas_por_silo");
        // 2. Create Gsoninstance
        Gson gson = new Gson();

        //3. check which JSON data is available and parse accordingly
        try {
            if (jsonLecturasPorSilo != null) {
                //a. Parse jsonLecturasPorSilo if available (para un silo especifico)
                LecturaContainer lecturaContainer = gson.fromJson(jsonLecturasPorSilo, LecturaContainer.class);
                listaLecturas.addAll(Arrays.asList(lecturaContainer.$values));
                Toast.makeText(this, "Mostrando Lecturas por Silo", Toast.LENGTH_SHORT).show();
            } else if (jsonString != null) {
                //b. Parse jsonLecturas if jsonLecturasPorSilo is not avaiable (para todas las lecturas)
                LecturaContainer lecturaContainer = gson.fromJson(jsonString, LecturaContainer.class);
                listaLecturas.addAll(Arrays.asList(lecturaContainer.$values));
                Toast.makeText(this, "Mostrando Todas las Lecturas", Toast.LENGTH_SHORT).show();
            } else {
                //c. Handle case where neiter jsonString nor jsonLecturasPorSilo is available
                Log.e("LecturasListActivity", "Neither jsonString nor jsonLecturasPorSilo are available");
                Toast.makeText(this, "No se encontraron lecturas", Toast.LENGTH_SHORT).show();
            }
            // . Set up RecyclerView
            adapter = new LecturaAdapter(listaLecturas);
            recyclerView.setLayoutManager(new LinearLayoutManager(this));
            recyclerView.setAdapter(adapter);
        } catch (JsonSyntaxException e) {
            e.printStackTrace();
            Toast.makeText(this, "Error al analizar el JSON", Toast.LENGTH_SHORT).show();
        }
    }
}
