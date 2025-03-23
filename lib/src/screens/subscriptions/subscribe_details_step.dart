import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SubscribeDetailsStep extends StatefulWidget {
  final int unitPrice;
  final String selectedPlan;

  const SubscribeDetailsStep({
    required this.selectedPlan,
    required this.unitPrice,
    super.key,
  });

  @override
  State<SubscribeDetailsStep> createState() => _SubscribeDetailsStepState();
}

class _SubscribeDetailsStepState extends State<SubscribeDetailsStep> {
  final TextEditingController _durationCtl = TextEditingController();
  int _amount = 0;
  String _error = '';

  @override
  void initState() {
    super.initState();

    _amount = widget.unitPrice;
    _durationCtl.text = '1';
  }

  String getInputLabel() {
    if (_durationCtl.text.isNotEmpty) {
      switch (widget.selectedPlan) {
        case 'jour':
          return int.parse(_durationCtl.text) > 1 ? 'JOURS' : 'JOUR';
        case 'semaine':
          return int.parse(_durationCtl.text) > 1 ? 'SEMAINES' : 'SEMAINE';
        case 'mois':
          return 'MOIS';
        case 'annee':
          return int.parse(_durationCtl.text) > 1 ? 'ANS' : 'AN';
        default:
          return '';
      }
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Veuillez preciser la duree de votre abonnement',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            SizedBox(
              width: 50,
              child: Consumer<SubscriptionProvider>(
                builder: (context, state, child) {
                  return TextField(
                    controller: _durationCtl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold, // Set font size here
                    ),
                    onChanged: (String text) {
                      if (text.isNotEmpty) {
                        setState(() {
                          _amount =
                              int.parse(_durationCtl.text) * state.unitPrice;
                        });
                      } else {
                        setState(() {
                          _amount = 0;
                        });
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              getInputLabel(),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        Text(
          _error != '' ? _error : '',
          style: const TextStyle(color: Colors.red),
        ),
        const SizedBox(
          height: 32,
        ),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Montant à payer : ', // Normal text
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black, // Text color
                ),
              ),
              TextSpan(
                text: '$_amount FCFA', // Bold text
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold, // Bold styling
                  color: Colors.black, // Text color
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 48,
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
                      .setStep('plan');
                },
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              ),
            ),
            Expanded(
              child: PrimaryButton(
                text: 'Continuer',
                onPressed: (context) {
                  if (_amount > 0) {
                    Provider.of<SubscriptionProvider>(context, listen: false)
                        .setDuration(int.parse(_durationCtl.text));
                    Provider.of<SubscriptionProvider>(context, listen: false)
                        .setAmount(_amount);
                    Provider.of<SubscriptionProvider>(context, listen: false)
                        .setStep('paymentMethod');
                  } else {
                    setState(() {
                      _error = 'Veuillez entrer une valeur supérieur à 0';
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
