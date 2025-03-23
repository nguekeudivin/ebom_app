import 'dart:convert';

import 'package:ebom/src/screens/subscriptions/subscribe_confirm_step.dart';
import 'package:ebom/src/screens/subscriptions/subscribe_details_step.dart';
import 'package:ebom/src/screens/subscriptions/subscribe_payment_mode_step.dart';
import 'package:ebom/src/screens/subscriptions/subscribre_plan_step.dart';
import 'package:ebom/src/services/payment_service.dart';
import 'package:ebom/src/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscribeModal extends StatefulWidget {
  const SubscribeModal({super.key});

  @override
  State<SubscribeModal> createState() => _SubscribeModalState();
}

class _SubscribeModalState extends State<SubscribeModal> {
  final SubscriptionService subscriptionService = SubscriptionService();
  final PaymentService paymentService = PaymentService();
  List<dynamic> _types = [];
  bool _loading = true;

  @override
  @override
  void initState() {
    super.initState();

    // Load payments methods.
    paymentService.methods().then(
          (methods) => {
            // ignore: use_build_context_synchronously
            Provider.of<SubscriptionProvider>(context, listen: false)
                .setPaymentMethods(methods),
          },
        );

    // Load subscription plans types.
    subscriptionService.types().then((types) {
      // Search for the current reference type
      // Set the default unit price.
      setState(() {
        _loading = false;
        _types = types;
      });

      Future.delayed(const Duration(milliseconds: 50), () {
        // Check login status.
        for (int i = 0; i < types.length; i++) {
          if (types[i]['reference'] ==
              // ignore: use_build_context_synchronously
              Provider.of<SubscriptionProvider>(context, listen: false)
                  .reference) {
            // ignore: use_build_context_synchronously
            Provider.of<SubscriptionProvider>(context, listen: false)
                .setUnitPrice(types[i]['prix_jour']);
            // ignore: use_build_context_synchronously
            Provider.of<SubscriptionProvider>(context, listen: false)
                .setReferenceId(types[i]['id']);
          }
        }
      });
    });
  }

  List<dynamic> getPlans(
    BuildContext context,
    List<dynamic> list,
    String reference,
  ) {
    List<dynamic> plans = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i]['reference'] == reference) {
        dynamic type = list[i];

        // Forfait jour.
        plans.add(
          json.decode(
            jsonEncode({
              'name': 'jour',
              'label': 'Forfait Jour',
              'priceLabel': '${type['prix_jour']} XAF/Jour',
              'price': type['prix_jour'],
            }),
          ),
        );

        // Forfait semaine
        plans.add(
          json.decode(
            jsonEncode({
              'name': 'semaine',
              'label': 'Forfait Semaine',
              'priceLabel': '${type['prix_semaine']} XAF/Semaine',
              'price': type['prix_semaine'],
            }),
          ),
        );

        // Forfait mois
        plans.add(
          json.decode(
            jsonEncode({
              'name': 'mois',
              'label': 'Forfait Mois',
              'priceLabel': '${type['prix_mois']} XAF/Mois',
              'price': type['prix_mois'],
            }),
          ),
        );

        // Forfait mois
        plans.add(
          json.decode(
            jsonEncode({
              'name': 'annee',
              'label': 'Forfait Annee',
              'priceLabel': '${type['prix_annee']} XAF/An',
              'price': type['prix_annee'],
            }),
          ),
        );
        break;
      }
    }

    return plans;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 600,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Consumer<SubscriptionProvider>(
          builder: (context, state, child) {
            switch (state.step) {
              case 'details':
                return SubscribeDetailsStep(
                  selectedPlan: state.selectedPlan,
                  unitPrice: state.unitPrice,
                );
              case 'paymentMethod':
                return const SubscribepaymentMethodStep();
              case 'confirm':
                return const SubscribeConfirmStep();

              default:
                return SubscribrePlanStep(
                  loading: _loading,
                  selectPlan: (plan, unitPrice) {
                    state.setSelectedPlan(plan);
                    state.setUnitPrice((unitPrice));
                  },
                  selectedPlan: state.selectedPlan,
                  plans: getPlans(context, _types, state.reference),
                );
            }
          },
        ),
      ),
    );
  }
}
