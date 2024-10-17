package com.example.silobolsamobileapp;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class LecturaAdapter extends RecyclerView.Adapter<LecturaAdapter.LecturaViewHolder> {
    private List<Lectura> listaLecturas;

    public LecturaAdapter(List<Lectura> listalecturas) {
        this.listaLecturas = listalecturas;
    }

    @NonNull
    @Override
    public LecturaViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.lecturas_item_layout, parent, false);
        return new LecturaViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull LecturaViewHolder holder, int position) {
        Lectura lectura = listaLecturas.get(position);
        holder.idLecturaTextView.setText(String.valueOf("Lectura " + lectura.idLectura));
        holder.idCajaTextView.setText(String.valueOf("Caja " + lectura.idCaja));
        holder.fechaHoraLecturaTextView.setText(String.valueOf("Fecha y hora: " + lectura.fechaHoraLectura));
        holder.temperaturaTextView.setText(String.valueOf("Temperatura: " + lectura.temp));
        holder.humedadTextView.setText(String.valueOf("Humedad: " + lectura.humedad));
        holder.dioxido_carbonoTextView.setText(String.valueOf("Dioxido de carbono: " + lectura.dioxidoDeCarbono));
    }

    @Override
    public int getItemCount() {
        return listaLecturas.size();
    }

    public static class LecturaViewHolder extends RecyclerView.ViewHolder {
        public TextView idLecturaTextView;
        public TextView idCajaTextView;
        public TextView fechaHoraLecturaTextView;
        public TextView temperaturaTextView;
        public TextView humedadTextView;
        public TextView dioxido_carbonoTextView;

        public LecturaViewHolder(View view) {
            super(view);
            idLecturaTextView = view.findViewById(R.id.idLecturaTextView);
            idCajaTextView = view.findViewById(R.id.idCajaTextView);
            fechaHoraLecturaTextView = view.findViewById(R.id.fechaHoraLecturaTextView);
            temperaturaTextView = view.findViewById(R.id.temperaturaTextView);
            humedadTextView = view.findViewById(R.id.humedadTextView);
            dioxido_carbonoTextView = view.findViewById(R.id.dioxido_carbonoTextView);
        }
    }
}

