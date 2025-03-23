import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/components/form/input_text.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/services/subscription_service.dart';
import 'package:ebom/src/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscribepaymentMethodStep extends StatefulWidget {
  const SubscribepaymentMethodStep({super.key});

  @override
  State<SubscribepaymentMethodStep> createState() =>
      _SubscribepaymentMethodStepState();
}

class _SubscribepaymentMethodStepState
    extends State<SubscribepaymentMethodStep> {
  final TextEditingController _phoneNumberCtl = TextEditingController();
  String _error = '';

  // final List<SelectOption> modes = [
  //   SelectOption(label: 'Orange Money', value: 'OM'),
  //   SelectOption(label: 'MTN Mobile Money', value: 'MOMO'),
  // ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, state, child) {
        return Column(
          children: [
            const Text(
              'Preciser les informations pour le paiement',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              children: List.generate(state.paymentMethods.length, (index) {
                return GestureDetector(
                  onTap: () {
                    state.setPaymentMethodId(state.paymentMethods[index]['id']);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: state.paymentMethodId ==
                                state.paymentMethods[index]['id']
                            ? AppColors.primary
                            : AppColors.borderGray,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Optional: Rounded corners
                    ),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .stretch, // Make the column fill width
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Space between items
                          children: [
                            Text(
                              state.paymentMethods[index]['nom']!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            state.paymentMethodId ==
                                    state.paymentMethods[index]['id']!
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                  )
                                : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 28,
            ),
            InputText(
              label: 'Numero de téléphone payeur',
              controller: _phoneNumberCtl,
            ),
            Text(
              _error != '' ? _error : '',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.blue200, // Background color
                    shape: BoxShape
                        .circle, // Optional: to make the background circular
                  ),
                  child: IconButton(
                    // onPressed: widget.onSearch,
                    onPressed: () {
                      Provider.of<SubscriptionProvider>(context, listen: false)
                          .setStep('details');
                    },
                    icon:
                        const Icon(Icons.arrow_back, color: AppColors.primary),
                  ),
                ),
                Expanded(
                  child: PrimaryButton(
                    text: 'Valider',
                    onPressed: (context) {
                      ValidationService validator = ValidationService();

                      if (validator.validatePhoneNumber(_phoneNumberCtl.text)) {
                        Provider.of<SubscriptionProvider>(
                          context,
                          listen: false,
                        ).setPhoneNumber(_phoneNumberCtl.text);
                        Provider.of<SubscriptionProvider>(
                          context,
                          listen: false,
                        ).setStep('confirm');
                      } else {
                        setState(() {
                          _error =
                              'Veuillez entrer une numéro de téléphone valide';
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
