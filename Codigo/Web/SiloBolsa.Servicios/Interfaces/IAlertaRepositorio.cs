using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces;
    public interface IAlertaRepositorio
    {
        IEnumerable<Alerta> GetAlertas();
        Alerta GetAlertaById(Guid id_alerta);
        Alerta GetAlertaActivaPorSilo(Guid id_silo);
        void AddAlerta(Alerta alerta);
        void UpdateAlerta(Alerta alerta);
        void DeleteAlerta(Guid id_alerta);
        void SaveChanges(); //Método para guardar cambios
    }