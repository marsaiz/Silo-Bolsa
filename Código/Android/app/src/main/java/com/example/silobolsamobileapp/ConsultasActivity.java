package com.example.silobolsamobileapp;

import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.os.StrictMode;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextClock;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;

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
    private TextView lecturasporSilo; //Para la consulta de lecturas por silotasPorSilo; //Para la consulta de lecturas por silo
    private TextView respuestaAlertas;
    private TextView alertasPorSilo;
    private TextView lecturasGraficosPorSilo;
    EditText idSilo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_consultas);

        idSilo = findViewById(R.id.idSiloeditText);

        //Necesario para permitir conexiones de red en el hilo principal (solo para este ejemplo)
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        Button botonGET = findViewById(R.id.siloConsulta);
        botonGET.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    //String respuestaGET = NetwokUtils.realizarPeticionGET("http://192.168.1.23:5006/api/silos");
                    String respuestaGET = NetwokUtils.realizarPeticionGET("http://172.23.5.215:5006/api/silos");
                    Log.d("respuesta", respuestaGET);
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

        Button botonGetIdSilo = findViewById(R.id.siloIdConsulta);
        botonGetIdSilo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String idSiloIngresado = idSilo.getText().toString();
                consultarSiloPorId(idSiloIngresado);
            }
        });

        Button botonConsultarLecturas = findViewById(R.id.consultarLecturas);
        botonConsultarLecturas.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    //String respuestaGET = NetwokUtils.realizarPeticionGET("http://192.168.1.21:5006/api/lecturas");
                    String respuestaGET = NetwokUtils.realizarPeticionGET("http://172.23.5.215:5006/api/lecturas");
                    Log.d("respuestaLecturas", respuestaGET);
                    Intent intent = new Intent(ConsultasActivity.this, LecturasListActivity.class);
                    intent.putExtra("json_lecturas", respuestaGET);
                    startActivity(intent);
                } catch (IOException e) {
                    Log.e("error", "Error al realizar la petición GET", e);
                    respuestaLecturas.setText("Error: " + e.getMessage());
                }
            }
        });

        lecturasporSilo = findViewById(R.id.idSiloeditText);
        Button botonLecturasPorSilo = findViewById(R.id.lecturasBySilo);
        botonLecturasPorSilo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String idSiloIngresado = idSilo.getText().toString();
                consultarLecturasPorSilo(idSiloIngresado);
            }
        });

        Button botonConsultarAlertas = findViewById(R.id.alertaConsulta);
        botonConsultarAlertas.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    //String respuestaGET = NetwokUtils.realizarPeticionGET("http://192.168.1.21:5006/api/alertas");
                    String respuestaGET = NetwokUtils.realizarPeticionGET("http://172.23.5.215:5006/api/alertas");
                    Log.d("respuestaAlertas", respuestaGET);
                    Intent intent = new Intent(ConsultasActivity.this, AlertaListActivity.class);
                    intent.putExtra("json_alertas", respuestaGET);
                    startActivity(intent);
                } catch (IOException e) {
                    Log.e("error", "Error al realizar la petición GET", e);
                    respuestaAlertas.setText("Error: " + e.getMessage());
                }
            }
        });

        alertasPorSilo = findViewById(R.id.idSiloeditText);
        Button botonConsultarAlertasPorSilo = findViewById(R.id.alertaIdConsulta);
        botonConsultarAlertasPorSilo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String idSiloIngresado = idSilo.getText().toString();
                consultarAlertasPorSilo(idSiloIngresado);
            }
        });

        Button btnIrAtras = findViewById(R.id.volverAtrasMenu);
        btnIrAtras.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ConsultasActivity.this, MenuActivity.class);
                startActivity(intent);
                finish();
            }
        });

        Button botonGraficoLecturas = findViewById(R.id.graficoLecturas);
        botonGraficoLecturas.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String idSiloIngresado = idSilo.getText().toString();
                consultarGraficoLecturasPorSilo(idSiloIngresado);
            }
        });
    }

    private void consultarSiloPorId(String idSilo) {
        try {
            Silo silo = SiloRepository.GetSiloById(idSilo);
            Intent intent = new Intent(this, SiloDetailActivity.class);
            intent.putExtra("silo", silo);
            startActivity(intent);
        } catch (IOException | JSONException e) {
            Log.e("ConsultasActivity", "Error al consultar silo por ID", e);
            respuestaIdSilo.setText("Error: " + e.getMessage());

            //Mostrar un Toast con el mensaje de error
            Toast.makeText(this, "Error al consultar silo por ID: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    private void consultarLecturasPorSilo(String idSilo) {
        try {
            //Get the LecturaContainer from siloRepositorio
            SiloRepository siloRepository = new SiloRepository();
            //Crear an instance
            LecturaContainer lecturaContainer = siloRepository.GetLecturasBySilo(idSilo);
            //Convert to JSON
            String jsonLecturas = gson.toJson(lecturaContainer);
            //Create an Intent and pass te JSON data
            Intent intent = new Intent(this, LecturasListActivity.class);
            intent.putExtra("json_lecturas_por_silo", jsonLecturas);
            startActivity(intent);
        } catch (IOException | JSONException e) {
            Log.e("ConsultasLecturaPorSilo", "Error al consultar lecturas por silo", e);
            respuestaLecturas.setText("Error: " + e.getMessage());
            Toast.makeText(this, "Error al consultar lecturas por silo: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    private void consultarAlertasPorSilo(String idSilo) {
        try {
            SiloRepository siloRepository = new SiloRepository();
            AlertaContainer alertaContainer = siloRepository.GetAlertasBySilo(idSilo);
            String jsonAlertas = gson.toJson(alertaContainer);
            Intent intent = new Intent(this, AlertaListActivity.class);
            intent.putExtra("Json_alertas_por_silo", jsonAlertas);
            startActivity(intent);
        } catch (IOException | JSONException e) {
            Log.e("ConsultaAlertasPorSilo", "error al consultar lecturas por silo", e);
            respuestaAlertas.setText("Error: " + e.getMessage());
            Toast.makeText(this, "Error al consultar alertar por silo: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    private void consultarGraficoLecturasPorSilo(String idSilo) {
        try {
            SiloRepository siloRepository = new SiloRepository();
            //Crear an instance
            LecturaContainer lecturaContainer = siloRepository.GetLecturasBySilo(idSilo);
            //Convert to JSON
            String jsonLecturas = gson.toJson(lecturaContainer);
            Intent intent1 = new Intent(this, CharActivityTemp.class);
            intent1.putExtra("json_lecturas_por_silo", jsonLecturas);
            startActivity(intent1);
        } catch (IOException | JSONException e) {
            Log.e("ConsultasLecturaPorSilo", "Error al consultar lecturas por silo", e);
            respuestaLecturas.setText("Error: " + e.getMessage());
            Toast.makeText(this, "Error al consultar lecturas por silo: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    private Gson gson = new Gson();
}