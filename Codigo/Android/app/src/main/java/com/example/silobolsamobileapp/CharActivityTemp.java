package com.example.silobolsamobileapp;

import android.graphics.Color;
import android.os.Bundle;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter;
import com.google.gson.Gson;

import org.json.JSONException;

import java.util.ArrayList;
import java.util.List;

public class CharActivityTemp extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_char_temp);

        LineChart chartTemperatura = findViewById(R.id.lineChartTemperature);
        String jsonString = getIntent().getStringExtra("json_lecturas");
        String jsonlecturasPorSilo = getIntent().getStringExtra("json_lecturas_por_silo");

        Gson gson = new Gson();
        if (jsonlecturasPorSilo != null) {
            LecturaContainer lecturaContainer = gson.fromJson(jsonlecturasPorSilo, LecturaContainer.class);
            List<Entry> entries = new ArrayList<>();
            List<String> xAxisValues = new ArrayList<>();
            int i = 0;
            for (Lectura lectura : lecturaContainer.$values) {
                entries.add(new Entry(i++, (float) lectura.temp));
                xAxisValues.add(lectura.fechaHoraLectura);
            }
            LineDataSet dataSet = new LineDataSet(entries, "Temperatura");
            dataSet.setColor(Color.RED);
            LineData lineData = new LineData(dataSet);
            chartTemperatura.setData(lineData);

            XAxis xAxis = chartTemperatura.getXAxis();
            xAxis.setPosition(XAxis.XAxisPosition.BOTTOM);
            xAxis.setValueFormatter(new IndexAxisValueFormatter(xAxisValues));
            xAxis.setLabelRotationAngle(45f);

            chartTemperatura.getDescription().setEnabled(false); // Corrected this line                chartTemperatura.invalidate();
            chartTemperatura.invalidate();
        }
    }
}