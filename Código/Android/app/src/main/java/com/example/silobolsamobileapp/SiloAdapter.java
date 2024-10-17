package com.example.silobolsamobileapp;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;

public class SiloAdapter extends RecyclerView.Adapter<SiloAdapter.SiloViewHolder> {

    private List<Silo> listaSilos;

    public SiloAdapter(List<Silo> listaSilos) {
        this.listaSilos = listaSilos;
    }

    @NonNull
    @Override
    public SiloViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemview = LayoutInflater.from(parent.getContext()).inflate(R.layout.silo_item_layout, parent, false);
        return new SiloViewHolder(itemview);
    }

    @Override
    public void onBindViewHolder(@NonNull SiloAdapter.SiloViewHolder holder, int position) {
        Silo silo = listaSilos.get(position);
        holder.idSiloTextView.setText("Id Silo: " + String.valueOf(silo.idSilo));
        holder.latitudTextView.setText("Latitud: " + String.valueOf(silo.latitud));
        holder.longitudTextView.setText("Longitud: " + String.valueOf(silo.longitud));
        holder.capacidadTextView.setText("Capacidad: " + String.valueOf(silo.capacidad));
        holder.tipoGranoTextView.setText("Tipo de Grano: " + String.valueOf(silo.tipoGrano));
        holder.descripcionTextView.setText("Descripción: " + String.valueOf(silo.descripcion));
    }

    @Override
    public int getItemCount() {
        Log.d("SiloAdapter", "Tamaño de la lista: " + listaSilos.size());
        return listaSilos.size(); // Corregido: debe devolver el tamaño de la lista
    }

    public static class SiloViewHolder extends RecyclerView.ViewHolder {
        public TextView idSiloTextView;
        public TextView latitudTextView;
        public TextView longitudTextView;
        public TextView capacidadTextView;
        public TextView tipoGranoTextView;
        public TextView descripcionTextView;

        public SiloViewHolder(View view) {
            super(view);
            idSiloTextView = view.findViewById(R.id.idSiloTextView);
            latitudTextView = view.findViewById(R.id.latitudTextView);
            longitudTextView = view.findViewById(R.id.longitudTextView);
            capacidadTextView = view.findViewById(R.id.capacidadTextView);
            tipoGranoTextView = view.findViewById(R.id.tipoGranoTextView);
            descripcionTextView = view.findViewById(R.id.descripcionTextView);
        }
    }
}