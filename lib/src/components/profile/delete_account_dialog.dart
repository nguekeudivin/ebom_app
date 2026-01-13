import 'package:ebom/src/models/connexion.dart';
import 'package:ebom/src/screens/welcome_screen.dart';
import 'package:ebom/src/services/auth_service.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool _isLoading = false;

  Future<void> _submitDelete() async {
    setState(() => _isLoading = true);

    final connService = ConnexionService();
    final auth = AuthService();

    try {
      final Connexion? connexion = await connService.getConnexion();
      if (connexion == null) throw 'Utilisateur non trouvé';

      // ignore: use_build_context_synchronously
      final String deviceId = await auth.getDeviseId(context);

      DeleteAccountData data = DeleteAccountData(
        appareil: deviceId,
        email: connexion.email,
      );

      await auth.deleteAccount(data);
      await connService.logout();

      if (!mounted) return;

      // Nettoyage du provider et redirection
      Provider.of<ConnexionProvider>(context, listen: false).removeConnexion();
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false, // Supprime tout l'historique de navigation
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Affichage de l'erreur
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            error.toString(),
            style: const TextStyle(color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Supprimer mon compte'),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Important pour que le dialogue ne prenne pas tout l'écran
        children: [
          if (_isLoading) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Suppression en cours...',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Veuillez patienter, nous clôturons votre compte.',
              textAlign: TextAlign.center,
            ),
          ] else ...[
            const Text(
              'Voulez-vous vraiment supprimer votre compte ? Cette action est irréversible : toutes vos informations seront perdues et vos abonnements seront désactivés.',
            ),
          ],
        ],
      ),
      actions: _isLoading
          ? [] // On laisse vide pour empêcher toute interaction
          : [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ANNULER'),
              ),
              TextButton(
                onPressed: _submitDelete,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('SUPPRIMER'),
              ),
            ],
    );
  }
}