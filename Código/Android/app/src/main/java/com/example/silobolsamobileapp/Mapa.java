package com.example.silobolsamobileapp;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;

public class Mapa extends AppCompatActivity {

    private MapView mapView;
    private MapManager mapManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //mapView = findViewById(R.id.map);
        mapManager = new MapManager(mapView);

        // Ejemplo de uso
        GeoPoint startPoint = new GeoPoint(-35.9150100, -64.2944800);
        mapManager.setCenter(startPoint, 15.0);
        mapManager.addMarker(startPoint, "Eduardo Castex");
    }

    @Override
    protected void onResume() {
        super.onResume();
        mapManager.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
        mapManager.onPause();
    }

    // Método para obtener la ubicación actual y guardarla (puedes llamarlo
    // cuando el usuario encuentre el punto buscado)
    private void saveLocation() {
        GeoPoint location = mapManager.getCurrentLocation();
        // Aquí puedes guardar la ubicación en una base de datos, SharedPreferences, etc.
    }
}