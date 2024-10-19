namespace SiloBolsa.Servicios.Interfaces;

public interface IEmailServices
{
    Task SendEmail(string recipientEmail, string subject, string body);
}
