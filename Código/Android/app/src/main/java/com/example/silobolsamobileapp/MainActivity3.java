package com.example.silobolsamobileapp;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import org.json.JSONException;
import java.io.IOException;

public class MainActivity3 extends AppCompatActivity {
    int CODIGO_SOLICITADO_MAPA = 1;
    TextView longitudTextView;
    TextView latitudTextView;
    // Declarar los EditText como variables de instancia
    EditText latitudEditText;
    EditText longitudEditText;
    AutoCompleteTextView tipoGranoEditText;
    EditText capacidadEditText;
    EditText descripcionEditText;

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
                Intent intent = new Intent(MainActivity3.this, Mapa.class);
                startActivityForResult(intent, CODIGO_SOLICITADO_MAPA);
            }
        });

        String[] granos = new String[]{"Trigo", "Maíz", "Girasol", "Soja", "Arroz", "Cebada"};
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, granos);

        AutoCompleteTextView autoCompleteTextView = findViewById(R.id.TipoGrano);
        autoCompleteTextView.setAdapter(adapter);

        latitudEditText = findViewById(R.id.latitud);
        longitudEditText = findViewById(R.id.longitud);
        tipoGranoEditText = findViewById(R.id.TipoGrano);
        capacidadEditText = findViewById(R.id.capacidad);
        descripcionEditText = findViewById(R.id.descripcion);

        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        Button btnIrAtras = findViewById(R.id.volverAtras);
        btnIrAtras.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity3.this, MainActivity2.class);
                startActivity(intent);
                finish();
            }
        });

        Button enviarDatosButton = findViewById(R.id.enviarDatosButton);
        enviarDatosButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    //Obtener datos de los EditText
                    Double latitud = Double.parseDouble(latitudEditText.getText().toString());
                    Double longitud = Double.parseDouble(longitudEditText.getText().toString());

                    //Convertir el nombre del grano a su ID
                    int idGrano = obtenerIdGrano(tipoGranoEditText.getText().toString());

                    //String tipoGrano = tipoGranoEditText.getText().toString();
                    int capacidad = Integer.parseInt(capacidadEditText.getText().toString());
                    String descripcion = descripcionEditText.getText().toString();

                    String respuesta = NetwokUtils.realizarPeticionPOST("http://192.168.1.23:5006/api/silos", latitud, longitud, String.valueOf(idGrano), capacidad, descripcion);

                    //Mostrar la respuesta en el log
                    Log.d("Respuesta POST", respuesta);

                }catch (NumberFormatException e){
                    //Mostrar mensaje de error si los datos no son válidos
                    Toast.makeText(MainActivity3.this, "Por favor ingrese datos válidos", Toast.LENGTH_SHORT).show();
                    } catch (IOException | JSONException e) {
                    Toast.makeText(MainActivity3.this, "Error al enviar los datos", Toast.LENGTH_SHORT).show();
                    Log.e("Error POST", "Error al realizar la petición POST", e);
                }
            }
        });
    }
    //Funcion para convertir el nombre del grano a su ID
    private int obtenerIdGrano(String nombreGrano) {
        switch (nombreGrano) {
            case "Trigo":
                return 1;
            case "Maíz":
                return 2;
            case "Girasol":
                return 3;
            case "Soja":
                return 4;
            case "Arroz":
                return 5;
            case "Cebada":
                return 6;
            default:
                return 0;//o un valor que indique un error
        }
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
}