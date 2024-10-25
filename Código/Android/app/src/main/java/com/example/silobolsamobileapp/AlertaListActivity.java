package com.example.silobolsamobileapp;

import android.os.Bundle;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class AlertaListActivity extends AppCompatActivity {

    private RecyclerView recyclerView;
    private AlertaAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_alertas_list);

        recyclerView = findViewById(R.id.alertasRecyclerView);
        List<Alerta> alertasToDisplay; // Retener todas las alertas

        //Verifica si hay alertas filtradas
        if (getIntent().hasExtra("alertas_filtradas")) {
            alertasToDisplay = (List<Alerta>) getIntent().getSerializableExtra("alertas_filtradas");
        } else {
            //Muestra todas las alertas
            Gson gson = new Gson();
            String json = getIntent().getStringExtra("json_alertas");
            try {
                AlertaContainer alertaContainer = gson.fromJson(json, AlertaContainer.class);
                alertasToDisplay = Arrays.asList(alertaContainer.$values);


            } catch (JsonSyntaxException e) {
                Log.e("AlertaListActivity", "Error al deserializar JSON:" + e.getMessage());
                e.printStackTrace();
                alertasToDisplay = new ArrayList<>(); // Handle error gracefully
            }
        }

        adapter = new AlertaAdapter(alertasToDisplay);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(adapter);
    }
}
