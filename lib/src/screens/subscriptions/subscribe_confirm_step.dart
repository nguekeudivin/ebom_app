import 'dart:async';

import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/services/auth_service.dart';
import 'package:ebom/src/services/payment_service.dart';
import 'package:ebom/src/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscribeConfirmStep extends StatefulWidget {
  const SubscribeConfirmStep({super.key});

  @override
  State<SubscribeConfirmStep> createState() => _SubscribeConfirmStep();
}

class _SubscribeConfirmStep extends State<SubscribeConfirmStep> {
  Timer? _timer;
  String _status = '';

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null;
    }
  }

  String getTitle(String ref) {
    switch (ref) {
      case '@chat':
        return 'Vous allez souscrire à un abonnement pour le chat';
      case '@recherche':
        return 'Vous allez souscrire à un abonnement pour éffectuer des recherches';
      default:
        return 'Vous allez soucricre à un abonnement';
    }
  }

  void payAndSubcribe(SubscriptionProvider state) {
    AuthService authService = AuthService();
    PaymentService paymentService = PaymentService();
    SubscriptionService subscriptionService = SubscriptionService();

    authService.getDeviseId(context).then((deviseId) {
      if (state.pendingTransactionId == '') {
        paymentService
            .init(
          deviseId,
          state.phoneNumber,
          state.paymentMethodId,
          state.amount,
        )
            .then((paymentId) {
          setState(() {
            Timer.periodic(const Duration(seconds: 30), (timer) {
              paymentService.status(deviseId, paymentId).then((transactionId) {
                if (transactionId != '') {
                  // Save pending transasction id. The one that has not been use yet.
                  state.setPendingTransactionId(transactionId);

                  // Create the subscription.
                  subscriptionService
                      .create(
                    deviseId,
                    transactionId,
                    state.referenceId,
                    state.selectedPlan,
                    state.duration,
                  )
                      .then((data) {
                    state.setPendingTransactionId('');
                    setState(() {
                      _status = 'success';
                      timer.cancel();
                    });
                  }).catchError((error) {
                    setState(() {
                      _status = 'failed';
                      timer.cancel();
                    });
                  });
                }
              }).catchError((error) {
                setState(() {
                  _status = 'failed';
                  timer.cancel();
                });
              });
            });
          });
          // check status.
        }).catchError((error) {
          setState(() {
            _status = 'failed';
          });
        });
      } else {
        subscriptionService
            .create(
          deviseId,
          state.pendingTransactionId,
          state.referenceId,
          state.selectedPlan,
          state.duration,
        )
            .then((data) {
          setState(() {
            _status = 'success';
          });
        }).catchError((error) {
          setState(() {
            _status = 'failed';
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, state, child) {
        var data = state.getData();

        switch (_status) {
          case 'success':
            return SizedBox(
              height: 290,
              child: Column(
                //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.green200, // Background color
                      shape: BoxShape
                          .circle, // Optional: to make the background circular
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 48,
                      color: AppColors.green600,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const Text(
                    'Vous avez souscription a ete enregistree avec succes',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  PrimaryButton(
                    text: 'OK',
                    onPressed: (context) {
                      // Proceder au payment.
                      // Dismss modal
                      setState(() {
                        _status = ''; // Set the default status before closing.
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          case 'failed':
            return SizedBox(
              height: 300,
              child: Column(
                //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.redSoft, // Background color
                      shape: BoxShape
                          .circle, // Optional: to make the background circular
                    ),
                    child: const Icon(
                      Icons.warning_outlined,
                      size: 48,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    textAlign: TextAlign.center,
                    "Le service d'abonnement est momentanement indisponible. Veuillez resssayer plus tard.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'Ressayer',
                          onPressed: (context) {
                            // retry.
                            setState(() {
                              _status = 'loading';
                            });
                            payAndSubcribe(state);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ), // Add spacing between the buttons
                      Expanded(
                        child: PrimaryButton(
                          text: 'Annuler',
                          backgroundColor: AppColors.gray300,
                          onPressed: (context) {
                            // Proceder au payment.
                            setState(() {
                              _status =
                                  ''; // Set the default status before closing.
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          case 'loading':
            return const Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                Text(
                  'Paiement en cours...',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            );
          default:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTitle(
                    state.reference,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  data.length,
                  (index) {
                    final detail = data[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(detail['label']!),
                          Text(
                            detail['value']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
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
                          Provider.of<SubscriptionProvider>(
                            context,
                            listen: false,
                          ).setStep('paymentMethod');
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Confirmer',
                        onPressed: (context) {
                          // Proceder au payment.
                          _status = 'loading';
                          payAndSubcribe(state);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
        }
      },
    );
  }
}
