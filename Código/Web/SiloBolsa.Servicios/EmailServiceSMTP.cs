using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using SiloBolsa.Servicios.Interfaces;
using Microsoft.Extensions.Options;


namespace SiloBolsa.Servicios;

public class EmailServiceSMTP : IEmailServicesSMTP
{
    private readonly EmailSettings _emailSettings;
    private readonly ILogger<EmailServiceSMTP> _logger;

    public EmailServiceSMTP(IOptions<EmailSettings> emailSettings, ILogger<EmailServiceSMTP> logger)
    {
        _emailSettings = emailSettings.Value;
        _logger = logger;
    }

    public async Task SendEmailSMTP(string recipientEmail, string subject, string body)
    {
        var message = new MailMessage();
        message.From = new MailAddress(_emailSettings.SmtpUser, "Silo Alerta");
        message.To.Add(new MailAddress(recipientEmail));
        message.Subject = subject;
        message.Body = body;
        message.IsBodyHtml = true;

        using (var smtpClient = new SmtpClient(_emailSettings.SmtpServer, _emailSettings.SmtpPort))
        {
            smtpClient.EnableSsl = true;
            smtpClient.Credentials = new NetworkCredential(_emailSettings.SmtpUser, _emailSettings.SmtpPassword);

            try
            {
                await smtpClient.SendMailAsync(message);
            }
            catch (SmtpException ex)
            {
                _logger.LogError(ex, "Error en el envío del correo.");
            }
        }
    }
}