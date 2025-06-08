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
    String senderEmail = 'dissangfrancis@yahoo.com',
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
      <body>
        <h2>Bonjour $firstName $lastName,</h2>
        <p>Votre compte a été créé avec succès dans le système de gestion scolaire.</p>
        
        <h3>Vos informations de connexion :</h3>
        <ul>
          <li><strong>Email :</strong> $email</li>
          <li><strong>Identifiant unique :</strong> $userId</li>
          <li><strong>Mot de passe temporaire :</strong> $password</li>
          <li><strong>Rôle :</strong> $roleName</li>
        </ul>
        
        <p>Pour des raisons de sécurité, nous vous recommandons de changer votre mot de passe après votre première connexion.</p>
        
        <p>Cordialement,<br/>
        L'équipe de gestion scolaire  (
DABTOUTA NATHAN
Djappi jonathan
Patient Djappa
</p>
      </body>
    </html>
    """;
  }
}