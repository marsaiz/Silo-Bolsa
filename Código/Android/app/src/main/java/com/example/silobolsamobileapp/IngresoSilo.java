package com.example.silobolsamobileapp;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import org.json.JSONException;
import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class IngresoSilo extends AppCompatActivity {
    int CODIGO_SOLICITADO_MAPA = 1;
    TextView longitudTextView;
    TextView latitudTextView;
    // Declarar los EditText como variables de instancia
    EditText latitudEditText;
    EditText longitudEditText;
    private Spinner tipoGranoSpinner;
    EditText capacidadEditText;
    EditText descripcionEditText;
    private ExecutorService executor;
    private int selectedGrainTypeId = 1;

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
                Intent intent = new Intent(IngresoSilo.this, Mapa.class);
                startActivityForResult(intent, CODIGO_SOLICITADO_MAPA);
            }
        });

        GrainType[] tiposGranos = {new GrainType(1, "Trigo"), new GrainType(2, "Maíz"), new GrainType(3, "Girasol"), new GrainType(4, "Soja"), new GrainType(5, "Arroz"), new GrainType(6, "Cebada")};
        Spinner spinner = findViewById(R.id.TipoGrano);
        ArrayAdapter<GrainType> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, tiposGranos);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);

        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                GrainType selectedGrainType = (GrainType) parent.getItemAtPosition(position);
                selectedGrainTypeId = selectedGrainType.tipo_grano;
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });

        latitudEditText = findViewById(R.id.latitud);
        longitudEditText = findViewById(R.id.longitud);
        tipoGranoSpinner = findViewById(R.id.TipoGrano);
        capacidadEditText = findViewById(R.id.capacidad);
        descripcionEditText = findViewById(R.id.descripcion);

        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        Button btnIrAtras = findViewById(R.id.volverAtras);
        btnIrAtras.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(IngresoSilo.this, MenuActivity.class);
                startActivity(intent);
                finish();
            }
        });

        executor = Executors.newSingleThreadExecutor();

        Button enviarDatosButton = findViewById(R.id.enviarDatosButton);
        enviarDatosButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    //Obtener datos de los EditText
                    Double latitud = Double.parseDouble(latitudEditText.getText().toString());
                    Double longitud = Double.parseDouble(longitudEditText.getText().toString());
                    int capacidad = Integer.parseInt(capacidadEditText.getText().toString());
                    Log.d("IngresoSilo", "SelectedGrainTypeId: " + selectedGrainTypeId);
                    int tipo_grano = selectedGrainTypeId;
                    String descripcion = descripcionEditText.getText().toString();

                    //Enviar la tarea al ThreadPoolExecutor
                    executor.execute(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                String respuesta = NetwokUtils.realizarPeticionPOST("http://192.168.1.21:5006/api/silos", latitud, longitud, tipo_grano, capacidad, descripcion);
                                //String respuesta = NetwokUtils.realizarPeticionPOST("http://172.23.5.215:5006/api/silos", latitud, longitud, tipo_grano, capacidad, descripcion);

                                //Actualizar la UI en el hilo principal
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        //Mostrar la respuesta en el log
                                        Log.d("Respuesta POST", respuesta);
                                        //mostrar un toast con la respuesta o un mensaje de texto
                                        Toast.makeText(IngresoSilo.this, "Datos enviados correctamente", Toast.LENGTH_SHORT).show();

                                    }
                                });
                            } catch (NumberFormatException e) {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        //Mostrar mensaje de error si los datos no son válidos
                                        Toast.makeText(IngresoSilo.this, "Por favor ingrese datos válidos", Toast.LENGTH_SHORT).show();
                                    }
                                });
                            } catch (IOException | JSONException e) {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Toast.makeText(IngresoSilo.this, "Error al enviar los datos", Toast.LENGTH_SHORT).show();
                                        Log.e("Error POST", "Error al realizar la petición POST", e);
                                    }
                                });

                            }
                        }
                    });
                } catch (NumberFormatException e) {
                    //Mostrar mensaje de error si los datos no son válidos
                    Toast.makeText(IngresoSilo.this, "Por favor ingrese datos válidos", Toast.LENGTH_SHORT).show();
                }
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

    @Override
    protected void onDestroy() {
        super.onDestroy();
        //Apagamos el ExecutorService
        executor.shutdown();
    }

    public class GrainType {
        public int tipo_grano;
        public String nombreGrano;

        public GrainType(int tipo_grano, String nombreGrano) {
            this.tipo_grano = tipo_grano;
            this.nombreGrano = nombreGrano;
        }

        @Override
        public String toString() {
            return nombreGrano;
        }
    }
}