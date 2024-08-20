namespace SiloBolsa.App.Pantallas;

public class PantallaPrincipal
{
    public PantallaPrincipal()
    {

    }

    public void MostrarPantallaPrincial()
    {
        string? readResult;
        string menuSeleccion = "";

        do
        {
            Console.WriteLine("1. Visulizar Alerta");
            Console.WriteLine();
            Console.WriteLine("Digite una selección (o digite exit para salir)");

            readResult = Console.ReadLine();
            if(readResult != null)
            {
                menuSeleccion = readResult.ToLower();
            }

            switch (menuSeleccion)
            {
                case "1":
                    PantallaConsultarAlerta pantallaConsultarAlerta = new PantallaConsultarAlerta();
                    pantallaConsultarAlerta.ListarAlertas();
                    break;
            }
        }while (menuSeleccion != "exit");
    }

}
