using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Core.Interfaces
{
    public interface ILecturaRepositorio
    {
        IEnumerable<Lectura> GetLecturas();
        Lectura GetLecturaById(Guid id_lectura);
        void AddLectura(Lectura lectura);
        void UpdateLectura(Lectura lectura);
        void DeleteLectura(Guid id_lectura);
    }
}