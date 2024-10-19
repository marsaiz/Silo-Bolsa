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
    private List<Alerta> listaAlertas;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_alertas_list);

        recyclerView = findViewById(R.id.alertasRecyclerView);
        listaAlertas = new ArrayList<>();

        Gson gson = new Gson();
        String json = getIntent().getStringExtra("json_alertas");
        try {
            AlertaContainer alertaContainer = gson.fromJson(json, AlertaContainer.class);
            listaAlertas.addAll(Arrays.asList(alertaContainer.$values));
            adapter = new AlertaAdapter(listaAlertas);
            recyclerView.setLayoutManager(new LinearLayoutManager(this));
            recyclerView.setAdapter(adapter);

        } catch (JsonSyntaxException e) {
            Log.e("AlertaListActivity", "Erro ao deserializar JSON:" + e.getMessage());
            e.printStackTrace();
        }
    }
}
