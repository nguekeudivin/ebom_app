import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/components/form/input_text_area.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _nameCtl = TextEditingController();

  final TextEditingController _phoneNumberCtl = TextEditingController();

  final TextEditingController _messageCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Contactez-Nous',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Laissez nous un message en remplissant ce formulaire de contact.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputText(
                    controller: _nameCtl,
                    label: 'Nom',
                    placeholder: 'Entre votre nom',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputText(
                    controller: _phoneNumberCtl,
                    label: 'Numero de telephone',
                    placeholder: '+237 655660502',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputTextArea(
                    controller: _messageCtl,
                    label: 'Message',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: PrimaryButton(
                        text: 'Envoyer le message',
                        onPressed: (context) {
                          // Submit the form.
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
