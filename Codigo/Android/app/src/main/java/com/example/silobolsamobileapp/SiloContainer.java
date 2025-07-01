package com.example.silobolsamobileapp;

public class SiloContainer {
    //Se crea esta clase por que al incluir el ReferenceHandler en en program de la api
    //hecho para poder hacer las consultas de las lecturas asosicadas a distintas relaciones de cajas y silos
    //se modifico json con una ref.
    //* al tener relaciones entre silos, lecturas y cajas, es importante preservar las referencias para evitar
    // la duplicación de datos en el JSON y para mantener la integridad de las relaciones. Sin ReferenceHandler.
    // Preserve, el JSON podría contener varias copias del mismo objeto, lo que podría causar problemas al
    // deserializar el JSON en tu aplicación Android.*/
    public String $id;
    public Silo[] $values;
}
