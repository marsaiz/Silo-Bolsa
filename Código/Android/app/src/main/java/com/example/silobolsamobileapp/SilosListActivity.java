package com.example.silobolsamobileapp;

import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SilosListActivity extends AppCompatActivity {
    private RecyclerView recyclerView;
    private SiloAdapter adapter;
    private List<Silo> listaSilos;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_silos_list);

        recyclerView = findViewById(R.id.silosRecyclerView);
        listaSilos = new ArrayList<>();

        // 2. Parsear el JSON a objetos Silo
        Gson gson = new Gson();
        //Obtener el JSON del intent
        String jsonString = getIntent().getStringExtra("json_silos");
       //Convertir el JSON a un array de objetos Silo
       try {
           Silo[] silos = gson.fromJson(jsonString, Silo[].class);
           listaSilos.addAll(Arrays.asList(silos));

           // 3. Crear el Adapter y asignarlo al RecyclerView
           adapter = new SiloAdapter(listaSilos);

           // 4. Configurar el RecyclerView
           recyclerView.setLayoutManager(new LinearLayoutManager(this));
           recyclerView.setAdapter(adapter);
       }catch (JsonSyntaxException e){
           e.printStackTrace();
       }
    }
}