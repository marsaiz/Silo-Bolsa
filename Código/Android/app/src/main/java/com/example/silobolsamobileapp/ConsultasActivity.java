package com.example.silobolsamobileapp;

import android.content.Intent;
import android.os.Bundle;
import android.os.StrictMode;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;

import com.google.gson.Gson;

import org.json.JSONException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ConsultasActivity extends AppCompatActivity {
    private TextView respuesta; //Para la consulta de todos los silos
    private TextView respuestaIdSilo; //Para la consulta por ID silo
    private TextView respuestaLecturas; //Para la consulta de lecturas de una caja
    EditText idSilo;

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
                    String respuestaGET = NetwokUtils.realizarPeticionGET("http://192.168.1.21:5006/api/silos");
                    Log.d("respuesta", respuestaGET);
                    respuesta.setText("respuesta: " + respuestaGET);

                    //Crear un Intent para iniciar SiloListActivity
                    Intent intent = new Intent(ConsultasActivity.this, SilosListActivity.class);

                    //Pasar la respuestaGET a SiloListActivity
                    intent.putExtra("json_silos", respuestaGET);

                    //Iniciar SiloListActivity
                    startActivity(intent);

                } catch (IOException e) {
                    Log.e("error", "Error al realizar la petición GET", e);
                    respuesta.setText("Error: " + e.getMessage());
                }
            }
        });

        respuestaIdSilo = findViewById(R.id.siloConsultado);
        Button botonGetIdSilo = findViewById(R.id.siloIdConsulta);

        botonGetIdSilo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    //Obtener el ID del silo del EditText
                    idSilo = findViewById(R.id.idSiloeditText);
                    String idSiloIngresado = idSilo.getText().toString();
                    //LLamar al método GetSiloById()
                    Silo silo = SiloRepository.GetSiloById(idSiloIngresado);

                    //Usar el objeto silo obtenido y mostrar en un TextView
                    // respuestaIdSilo.setText("ID: " + silo.idSilo + "Latitud: " + silo.latitud);

                    //Crear una lista con el silo obtenido
                    List<Silo> listaSiloIndividual = new ArrayList<>();
                    listaSiloIndividual.add(silo);

                    //Crear un intent para iniciar la activity que muestra el RecyclerView
                    Intent intent = new Intent(ConsultasActivity.this, SilosListActivity.class);
                    //Pasar la lista de silos a la activity que muestra el RecyclerView
                    Gson gson = new Gson();
                    String jsonSiloIndividual = gson.toJson(listaSiloIndividual);
                    intent.putExtra("json_silos", jsonSiloIndividual);
                    //Iniciar la actividad
                    startActivity(intent);

                    //Código para pasar el silo obtenido a otra activity si es necesario
                    //Por ejemplo para una modificación

                } catch (IOException | JSONException e) {
                    Log.e("error", "Error al consultar silo por ID", e);
                    respuestaIdSilo.setText("eError: " + e.getMessage());
                }
            }
        });

        respuestaLecturas = findViewById(R.id.lecturasConsultadas);
        Button botonConsultarLecturas = findViewById(R.id.consultarLecturas);

        botonConsultarLecturas.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    String respuestaGET = NetwokUtils.realizarPeticionGET("http://192.168.1.21:5006/api/lecturas");
                    Log.d("respuestaLecturas", respuestaGET);
                    respuestaLecturas.setText("respuestaLecturas: " + respuestaGET);
                    Intent intent = new Intent(ConsultasActivity.this, LecturasListActivity.class);
                    intent.putExtra("json_lecturas", respuestaGET);
                    startActivity(intent);
                } catch (IOException e) {
                    Log.e("error", "Error al realizar la petición GET", e);
                    respuestaLecturas.setText("Error: " + e.getMessage());
                }
            }
        });
    }
}