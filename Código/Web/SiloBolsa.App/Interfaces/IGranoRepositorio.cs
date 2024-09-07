using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.App.Interfaces
{
    public interface IGranoRepositorio
    {
        IEnumerable<Grano> GetGranos();
        Grano GetGranoById(int id);
        void AddGrano(Grano grano);
        void UpdateGrno(Grano grano);
        void DeleteGrano(int id);
    }
}