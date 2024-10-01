package com.example.silobolsamobileapp;

import org.osmdroid.config.Configuration;
import org.osmdroid.events.MapEventsReceiver;
import org.osmdroid.tileprovider.tilesource.TileSourceFactory;

import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;
import org.osmdroid.views.overlay.MapEventsOverlay;
import org.osmdroid.views.overlay.Marker;


public class Mapa extends AppCompatActivity {

    private MapView mapView;
    private Marker currentMarker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mapa);

        Configuration.getInstance().load(getApplicationContext(),
                getSharedPreferences("osmdroid", 0));

        mapView = findViewById(R.id.map);
        mapView.setTileSource(TileSourceFactory.MAPNIK);
        mapView.setBuiltInZoomControls(true);
        mapView.setMultiTouchControls(true);

        GeoPoint startPoint = new GeoPoint(-35.9150100, -64.2944800); // Ejemplo: Eduardo Castex
        mapView.getController().setCenter(startPoint);
        mapView.getController().setZoom(15.0);

        MapEventsReceiver mReceive = new MapEventsReceiver() {
            @Override
            public boolean singleTapConfirmedHelper(GeoPoint p) {
                double latitud = p.getLatitude();
                double longitud = p.getLongitude();

                //Eliminar marcador anterior si existe
                if (currentMarker != null) {
                    mapView.getOverlays().remove(currentMarker);
                }

                // Crear un nuevo marcador en la posición seleccionada
                currentMarker = new Marker(mapView);
                currentMarker.setPosition(p);
                mapView.getOverlays().add(currentMarker);

                // Pasar coordenadas a la Activity anterior y finalizar
                Intent intent = new Intent();
                intent.putExtra("latitud", latitud);
                intent.putExtra("longitud", longitud);
                setResult(MainActivity3.RESULT_OK, intent);
                finish();
                return true;
            }

            @Override
            public boolean longPressHelper(GeoPoint p) {
                return false;
            }
        };
        //Detectar eventos de mapa como clics y pulsaciones
        MapEventsOverlay OverlayEventos = new MapEventsOverlay(getBaseContext(), mReceive);
        mapView.getOverlays().add(OverlayEventos);
    }

    @Override
    protected void onResume() {
        super.onResume();
        mapView.onResume();
    }
    @Override
    protected void onPause() {
        super.onPause();
        mapView.onPause();
    }
}