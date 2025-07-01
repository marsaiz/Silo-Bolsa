namespace SiloBolsa.Servicios.Interfaces;

public interface IEmailServicesSMTP
{
    Task SendEmailSMTP(string recipientEmail, string subject, string body);
}
