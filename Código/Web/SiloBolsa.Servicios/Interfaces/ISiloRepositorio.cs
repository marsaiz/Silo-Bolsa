using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces
{
    public interface ISiloRepositorio
    {
        IEnumerable<Silo> GetSilos();
        Silo GetSiloById(Guid id_silo);
        void AddSilo(Silo silo);
        void UpdateSilo(Silo silo);
        void DeleteSilo(Guid id_silo);
    }
}