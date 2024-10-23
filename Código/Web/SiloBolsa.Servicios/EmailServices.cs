using MailKit.Net.Smtp;
using MimeKit;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using SiloBolsa.Servicios.Interfaces;
using Microsoft.Extensions.Options;


namespace SiloBolsa.Servicios;

public class EmailServices : IEmailServices
{

    //SmtpClientClass
    private readonly EmailSettings _emailSettings;
    private readonly ILogger<EmailServices> _logger;

//En el constructor se usa IOptions<> para usar los valores del archivo de configuracion
//En este ejemplo para usar la clase EmailSettings
    public EmailServices(IOptions<EmailSettings> emailSettings, ILogger<EmailServices> logger)
    {
        _emailSettings = emailSettings.Value;
        _logger = logger;
    }

    public async Task SendEmail(string recipientEmail, string subject, string body)
    {
        var message = new MimeMessage();
        message.From.Add(new MailboxAddress("Silo Alerta", _emailSettings.SmtpUser));
        message.To.Add(new MailboxAddress("", recipientEmail));
        message.Subject = subject;

        message.Body = new TextPart("html")
        {
            Text = body
        };

        using (var client = new SmtpClient())
        {
            try
            {
                await client.ConnectAsync(_emailSettings.SmtpServer, _emailSettings.SmtpPort, MailKit.Security.SecureSocketOptions.StartTls);
                await client.AuthenticateAsync(_emailSettings.SmtpUser, _emailSettings.SmtpPassword);

                await client.SendAsync(message);
                await client.DisconnectAsync(true);
            }
            catch (Exception e)
            {
                _logger.LogError(e, "Error en el envio de la alerta.");
            }
        }
    }
}
