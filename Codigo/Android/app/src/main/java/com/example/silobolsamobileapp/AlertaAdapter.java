package com.example.silobolsamobileapp;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class AlertaAdapter extends RecyclerView.Adapter<AlertaAdapter.AlertaViewHolder> {
    private List<Alerta> listaAlertas;

    public AlertaAdapter(List<Alerta> listaAlertas) {
        this.listaAlertas = listaAlertas;
    }

    @NonNull
    @Override
    public AlertaViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.alertas_item_layout, parent, false);
        return new AlertaViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull AlertaViewHolder holder, int position) {
        Alerta alerta = listaAlertas.get(position);
        holder.idAlertaTextView.setText("Alerta ID: " + String.valueOf(alerta.idAlerta));
        holder.fechaHoraAlertaTextView.setText("Fecha y Hora: " + String.valueOf(alerta.fechaHoraAlerta));
        holder.mensajeAlertaTextView.setText("Mensaje: " + String.valueOf(alerta.mensaje));
        holder.idSiloTextView.setText("Id Silo: " + String.valueOf(alerta.idSilo));
    }

    @Override
    public int getItemCount() {
        Log.d("AlertaAdapter", "getItemCount: " + listaAlertas.size());
        return listaAlertas.size();
    }

    public static class AlertaViewHolder extends RecyclerView.ViewHolder {
        public TextView idAlertaTextView;
        public TextView fechaHoraAlertaTextView;
        public TextView mensajeAlertaTextView;
        public TextView idSiloTextView;

        public AlertaViewHolder(View view) {
            super(view);
            idAlertaTextView = view.findViewById(R.id.idAlertaTextView);
            fechaHoraAlertaTextView = view.findViewById(R.id.fechaHoraAlertaTextView);
            mensajeAlertaTextView = view.findViewById(R.id.mensajeAlertaTextView);
            idSiloTextView = view.findViewById(R.id.idSiloTextView);
        }
    }
}

