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
            Console.WriteLine("Ingrese el número de la opción elegida");
            Console.WriteLine("1. Cargar Silo");
            Console.WriteLine("2 Consultar Silos");
            Console.WriteLine("3. Visualizar alerta");
            Console.WriteLine("4. Crear alerta");
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
                    PantallaAgregarSilo pantallaAgregarSilo = new PantallaAgregarSilo();
                    pantallaAgregarSilo.MostrarPantallaAccion();
                break;

                case "2":
                    PantallaConsultarSilo pantallaConsultarSilo = new PantallaConsultarSilo();
                    pantallaConsultarSilo.ListarSilos();
                    break;
                case "3":
                    PantallaConsultarAlerta pantallaConsultarAlerta = new PantallaConsultarAlerta();
                    pantallaConsultarAlerta.ListarAlertas();
                    break;
                case "4":
                    PantallaAgregarAlerta pantallaAgregarAlerta = new PantallaAgregarAlerta();
                    pantallaAgregarAlerta.MostrarPantallaAccion();
                    break;
            }
        }while (menuSeleccion != "exit");
    }

}
