using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SiloBolsa.Persistencia.Modelos;
using SiloBolsa.Persistencia.Repositorios;

namespace SiloBolsa.App.Interfaces;
    public interface IAlertaRepositorio
    {
        IEnumerable<Alerta> GetAlertas();
        Alerta GetAlertaById(Guid id_alerta);
        void AddAlerta(Alerta alerta);
        void UpdateAlerta(Alerta alerta);
        void DeleteAlerta(Guid id_alerta);
    }