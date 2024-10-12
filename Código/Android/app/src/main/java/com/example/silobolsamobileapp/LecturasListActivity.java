package com.example.silobolsamobileapp;

import android.annotation.SuppressLint;
import android.os.Bundle;

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

        Gson gson = new Gson();
        String jsonString = getIntent().getStringExtra("json_lecturas");

        try {
            Lectura[] lecturas = gson.fromJson(jsonString, Lectura[].class);
            listaLecturas.addAll(Arrays.asList(lecturas));
            adapter = new LecturaAdapter(listaLecturas);
            recyclerView.setLayoutManager(new LinearLayoutManager(this));
            recyclerView.setAdapter(adapter);
        } catch (JsonSyntaxException e) {
            e.printStackTrace();
        }
    }
}
