using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Core.Interfaces
{
    public interface ISensoresRepositorio
    {
        IEnumerable<Sensores> GetSensores();
        Sensores GetSensoresById(Guid id_caja);
        void AddSensores(Sensores sensores);
        void UpdateSensores(Sensores sensores);
        void DeleteSensores(Guid id_caja);
    }
}