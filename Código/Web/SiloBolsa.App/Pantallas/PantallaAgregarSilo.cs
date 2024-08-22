using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SiloBolsa.Core.Modelos;
using SiloBolsa.Core.Negocio;
using SiloBolsa.Persistencia.Negocio;
using SiloBolsa.Persistencia.Repositorios;

namespace SiloBolsa.App.Pantallas
{
    public class PantallaAgregarSilo
    {
         private SiloServicio _siloServicio;

        public PantallaAgregarSilo()
        {
            _siloServicio = new SiloServicio();
        }

        public void MostrarPantallaAccion()
        {
            float latitud;
            float longitud;
            int capacidad = 0;
            int tipoGrano = 0;

            Console.WriteLine("Ingrese latitdu del silo: ");
            string latitudEntrada = Console.ReadLine();

            Console.WriteLine("Ingrese longitud del silo: ");
            string longitudEntrada = Console.ReadLine();

            Console.Write("Ingrese capacidad del silo: ");
            string capacidadEntrada = Console.ReadLine();
            Console.WriteLine("Ingrese tipo de grano (1.Maíz\n2.Soja\n3.Trigo\n4.Girasol\n5.Arroz): ");
            string tipoGranoEntrada = Console.ReadLine();

            try
            {
                latitud = float.Parse(latitudEntrada);
                longitud = float.Parse(longitudEntrada);
                capacidad = int.Parse(capacidadEntrada);
                tipoGrano = int.Parse(tipoGranoEntrada);

                Silo silo = new Silo();
                silo.Latitud = latitud;
                silo.Longitud = longitud;
                silo.Capacidad = capacidad;
                silo.TipoGrano = tipoGrano;
                _siloServicio.AgregarSilo(silo);
            }
            catch (FormatException)
            {
                Console.WriteLine("Datos ingresados incorrectos.");
            }

        }
    }
}