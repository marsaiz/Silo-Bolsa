using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Negocio;
using SiloBolsa.Persistencia.Repositorios;

namespace SiloBolsa.App.Pantallas
{
    public class PantallaAgregarAlerta
    {
        private AlertaServicio _alertaServicio;

        public PantallaAgregarAlerta()
        {
            _alertaServicio = new AlertaServicio();
        }

        public void MostrarPantallaAccion()
        {
            DateOnly fechaAlerta;
            TimeOnly horaAlerta;
            int idSilo;
            Console.WriteLine("Ingrese el id del silo: ");
            string entrada = Console.ReadLine();

            Console.WriteLine("Ingrese fecha de la alerta (formato YYYY-MM-DD): ");
            string inputFecha = Console.ReadLine();
            Console.Write("Ingrese la hora (formato HH:mm): ");
            string inputHora = Console.ReadLine();
            Console.WriteLine("Ingrese el mensaje de alerta: ");
            string mensaje = Console.ReadLine();

            try
            {
                fechaAlerta = DateOnly.Parse(inputFecha);
                horaAlerta = TimeOnly.Parse(inputHora);
                idSilo = int.Parse(entrada);

                Alerta alerta = new Alerta();
                alerta.IdSilo = idSilo;
                alerta.FechaAlerta = fechaAlerta;
                alerta.HoraAlerta = horaAlerta;
                alerta.Mensaje = mensaje;
                _alertaServicio.AgregarAlerta(alerta);
            }
            catch (FormatException)
            {
                Console.WriteLine("El formato de la fecha o la hora no es válido.");
            }

        }
    }
}