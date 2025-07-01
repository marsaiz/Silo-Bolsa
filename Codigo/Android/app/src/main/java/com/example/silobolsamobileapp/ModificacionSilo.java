package com.example.silobolsamobileapp;

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

public class ModificacionSilo extends AppCompatActivity {
    int CODIGO_SOLICITADO_MAPA = 1;
    TextView latitudTextView;
    TextView longitudTextView;
    EditText latitudEditText;
    EditText longitudEditText;
    EditText descripcionEditText;
    private Spinner tipoGranoSpinner;
    EditText capacidadEditText;
    EditText getDescripcionEditText;
    private ExecutorService executor;
    private int selectedGrainTypeId = 1;
    EditText idSiloEditText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_modificacion_silo);

        latitudTextView = findViewById(R.id.newLatitud);
        longitudTextView = findViewById(R.id.newLongitud);

        Button irAMapa = findViewById(R.id.buscarEnMapaModificaciones);
        irAMapa.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ModificacionSilo.this, Mapa.class);
                startActivityForResult(intent, CODIGO_SOLICITADO_MAPA);
            }
        });

        GrainTypeModificaciones[] tiposGranos = {new GrainTypeModificaciones(1, "Trigo"), new GrainTypeModificaciones(2, "Maíz"), new GrainTypeModificaciones(3, "Girasol"), new GrainTypeModificaciones(4, "Soja"), new GrainTypeModificaciones(6, "Arroz"), new GrainTypeModificaciones(7, "Cebada")};
        Spinner spinner = findViewById(R.id.NewTipoGrano);
        ArrayAdapter<GrainTypeModificaciones> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, tiposGranos);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);

        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                GrainTypeModificaciones selectedGrainType = (GrainTypeModificaciones) parent.getItemAtPosition(position);
                selectedGrainTypeId = selectedGrainType.tipo_grano;
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });
        idSiloEditText = findViewById(R.id.idSiloModieditText);
        latitudEditText = findViewById(R.id.newLatitud);
        longitudEditText = findViewById(R.id.newLongitud);
        descripcionEditText = findViewById(R.id.newDescripcion);
        capacidadEditText = findViewById(R.id.newCapacidad);
        tipoGranoSpinner = findViewById(R.id.NewTipoGrano);

        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        Button btnIrAtras = findViewById(R.id.btnIrAtras);

        btnIrAtras.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ModificacionSilo.this, MenuActivity.class);
                startActivity(intent);
            }
        });
        executor = Executors.newSingleThreadExecutor();

        Button enviarModitifacionesButton = findViewById(R.id.enviarModificaciones);
        enviarModitifacionesButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    String idSilo = idSiloEditText.getText().toString();
                    Double latidud = Double.parseDouble(latitudEditText.getText().toString());
                    Double longitud = Double.parseDouble(longitudEditText.getText().toString());
                    String descripcion = descripcionEditText.getText().toString();
                    int capacidad = Integer.parseInt(capacidadEditText.getText().toString());
                    int tipo_grano = selectedGrainTypeId;

                    //String url = "http://192.168.1.23:5006/api/silos/" + idSilo;
                    //String url = "http://172.23.5.215:5006/api/silos/" + idSilo;
                    String url = "http://77.81.230.76:5096/api/silos/" + idSilo;
                    executor.execute(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                String respuesta = NetwokUtils.realizarPeticionPUT(url, latidud, longitud, tipo_grano, capacidad, descripcion);
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Log.d("respuesta PUT", respuesta);
                                        Toast.makeText(ModificacionSilo.this, "Silo modificado correctamente", Toast.LENGTH_SHORT).show();
                                    }
                                });
                            } catch (NumberFormatException e) {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Toast.makeText(ModificacionSilo.this, "Error al modificar el silo", Toast.LENGTH_SHORT).show();
                                    }
                                });
                            } catch (IOException | JSONException e) {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Toast.makeText(ModificacionSilo.this, "Error al enviar los nuevos datos", Toast.LENGTH_SHORT).show();
                                        Log.e("Error PUT", "Error al realizar la peticion PUT", e);
                                    }
                                });
                            }
                        }
                    });
                } catch (NumberFormatException e) {
                    Toast.makeText(ModificacionSilo.this, "Por favor ingrese valores válidos", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CODIGO_SOLICITADO_MAPA && resultCode == RESULT_OK) {
            double latitud = data.getDoubleExtra("latitud", 0.0);
            double longitud = data.getDoubleExtra("longitud", 0.0);
            latitudEditText.setText(String.valueOf(latitud));
            longitudEditText.setText(String.valueOf(longitud));
        } else {
            latitudEditText.setText("Coordenadas no seleccionadas");
            longitudEditText.setText("Coordenadas no seleccionadas");
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        executor.shutdown();
    }

    public class GrainTypeModificaciones {
        public int tipo_grano;
        public String nombreGrano;

        public GrainTypeModificaciones(int tipo_grano, String nombreGrano) {
            this.tipo_grano = tipo_grano;
            this.nombreGrano = nombreGrano;
        }

        @Override
        public String toString() {
            return nombreGrano;
        }
    }
}
