import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  final String _smtpServer;
  final String _smtpUsername;
  final String _smtpPassword;
  final int _smtpPort;
  final String _senderEmail;
  final String _senderName;

  EmailService({
    required String smtpServer,
    required String smtpUsername,
    required String smtpPassword,
    int smtpPort = 587,
    String senderEmail = 'patientdjappa@gmail.com',
    String senderName = 'Système de Gestion Scolaire KEYCE',
  })  : _smtpServer = smtpServer,
        _smtpUsername = smtpUsername,
        _smtpPassword = smtpPassword,
        _smtpPort = smtpPort,
        _senderEmail = senderEmail,
        _senderName = senderName;

  Future<void> sendAccountCreationEmail({
    required String recipientEmail,
    required String password,
    required String firstName,
    required String lastName,
    required String userId,
    required String roleName,
  }) async {
    try {
      final smtpServer = SmtpServer(
        _smtpServer,
        username: _smtpUsername,
        password: _smtpPassword,
        port: _smtpPort,
        ssl: false,
        allowInsecure: true,
      );

      final message = Message()
        ..from = Address(_senderEmail, _senderName)
        ..recipients.add(recipientEmail)
        ..subject = 'Votre compte a été créé'
        ..html = _buildAccountCreationEmailHtml(
          firstName: firstName,
          lastName: lastName,
          email: recipientEmail,
          userId: userId,
          password: password,
          roleName: roleName,
        );

      await send(message, smtpServer);
    } catch (e) {
      print('Erreur lors de l\'envoi de l\'email: $e');
      // Vous pourriez logger cette erreur dans Firestore/Crashlytics
      rethrow; // Optionnel - à adapter selon votre gestion d'erreurs
    }
  }

String _buildAccountCreationEmailHtml({
  required String firstName,
  required String lastName,
  required String email,
  required String userId,
  required String password,
  required String roleName,
}) {
  return """
  <html>
    <head>
      <style>
        body {
          font-family: Arial, sans-serif;
          background-color: #f4f4f4;
          color: #333;
          padding: 20px;
        }
        .container {
          background-color: #ffffff;
          padding: 20px;
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          max-width: 600px;
          margin: auto;
        }
        h2 {
          color: #2c3e50;
        }
        ul {
          list-style: none;
          padding: 0;
        }
        ul li {
          padding: 8px 0;
        }
        strong {
          color: #2980b9;
        }
        .footer {
          margin-top: 20px;
          font-size: 14px;
          color: #777;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h2>Bonjour $firstName $lastName,</h2>
        <p>Votre compte a été <strong>créé avec succès</strong> dans le système de gestion scolaire.</p>

        <h3>🎓 Vos informations de connexion :</h3>
        <ul>
          <li><strong>Email :</strong> $email</li>
          <li><strong>Identifiant unique :</strong> $userId</li>
          <li><strong>Mot de passe temporaire :</strong> $password</li>
          <li><strong>Rôle :</strong> $roleName</li>
        </ul>

        <p style="margin-top: 20px;">
          🔐 <em>Pour votre sécurité, veuillez changer votre mot de passe après votre première connexion.</em>
        </p>

        <div class="footer">
          Cordialement,<br/>
          L'équipe de gestion scolaire :<br/>
          Dabtouta Nathan, Djappi Jonathan, Patient Djappa
        </div>
      </div>
    </body>
  </html>
  """;
}

}
