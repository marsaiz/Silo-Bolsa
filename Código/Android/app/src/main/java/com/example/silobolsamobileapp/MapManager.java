package com.example.silobolsamobileapp;

import org.osmdroid.config.Configuration;
import org.osmdroid.tileprovider.tilesource.TileSourceFactory;
import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;
import org.osmdroid.views.overlay.Marker;

public class MapManager {

    private MapView mapView;
    private GeoPoint currentLocation;

    public MapManager(MapView mapView) {
        this.mapView = mapView;
        Configuration.getInstance().load(mapView.getContext(),
                mapView.getContext().getSharedPreferences("osmdroid", 0));
        mapView.setTileSource(TileSourceFactory.MAPNIK); // Corregido: setTileSource
        mapView.setBuiltInZoomControls(true);
        mapView.setMultiTouchControls(true);
    }

    public void setCenter(GeoPoint point, double zoom) {
        mapView.getController().setCenter(point);
        mapView.getController().setZoom(zoom);
        currentLocation = point;
    }

    public void addMarker(GeoPoint point, String title) {
        Marker marker = new Marker(mapView);
        marker.setPosition(point);
        marker.setTitle(title);
        marker.setAnchor(Marker.ANCHOR_CENTER, Marker.ANCHOR_BOTTOM);
        mapView.getOverlays().add(marker); // Corregido: getOverlays
        marker.setTitle(title);
    }

    public GeoPoint getCurrentLocation() {
        return currentLocation;
    }

    public void onResume() {
        mapView.onResume();
    }

    public void onPause() {
        mapView.onPause();
    }
}