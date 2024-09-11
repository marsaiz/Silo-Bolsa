namespace SiloBolsa.App.Pantallas;

public class PantallaPrincipal
{

    private readonly PantallaAgregarSilo _pantallaAgregarSilo;
    private readonly PantallaConsultarSilo _pantallaConsultarSilo;
    private readonly PantallaConsultarAlerta _pantallaConsultarAlerta;
    private readonly PantallaAgregarAlerta _pantallaAgregarAlerta;

    public PantallaPrincipal(PantallaAgregarSilo pantallaAgregarSilo,
        PantallaConsultarSilo pantallaConsultarSilo,
        PantallaConsultarAlerta pantallaConsultarAlerta,
        PantallaAgregarAlerta pantallaAgregarAlerta)
    {
        _pantallaAgregarSilo = pantallaAgregarSilo;
        _pantallaConsultarSilo = pantallaConsultarSilo;
        _pantallaConsultarAlerta = pantallaConsultarAlerta;
        _pantallaAgregarAlerta = pantallaAgregarAlerta;
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
            if (readResult != null)
            {
                menuSeleccion = readResult.ToLower();
            }

            switch (menuSeleccion)
            {
                case "1":
                    _pantallaAgregarSilo.MostrarPantallaAccion();
                    break;
                case "2":
                    _pantallaConsultarSilo.ListarSilos();
                    break;
                case "3":
                    _pantallaConsultarAlerta.ListarAlertas();
                    break;
                case "4":
                    _pantallaAgregarAlerta.MostrarPantallaAccion();
                    break;
            }
        } while (menuSeleccion != "exit");
    }

}
