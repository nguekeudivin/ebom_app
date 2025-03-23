import 'package:ebom/src/components/button/primary_button.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscribrePlanStep extends StatefulWidget {
  final List<dynamic> plans;
  final bool loading;
  final String selectedPlan;
  final void Function(String name, int price) selectPlan;

  const SubscribrePlanStep({
    required this.loading,
    required this.plans,
    required this.selectPlan,
    required this.selectedPlan,
    super.key,
  });

  @override
  State<SubscribrePlanStep> createState() => _SubscribrePlanStepState();
}

class _SubscribrePlanStepState extends State<SubscribrePlanStep> {
  String subscribeTitle() {
    switch (
        Provider.of<SubscriptionProvider>(context, listen: false).reference) {
      case '@recherche':
        return 'Veuillez souscrire à un forfait pour effectuer une recherche';
      case '@chat':
        return 'Veuillez souscrire à un forfait pour chatter';
      default:
        return 'Veuillez souscrire à un forfait pour continuer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          subscribeTitle(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        widget.loading
            ? const Column(
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  CircularProgressIndicator(),
                ],
              )
            : Column(
                children: List.generate(widget.plans.length, (index) {
                  var plan = widget.plans[index];
                  return GestureDetector(
                    onTap: () {
                      widget.selectPlan(plan['name'], plan['price']);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.selectedPlan == plan['name']
                              ? AppColors.primary
                              : AppColors.borderGray,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // Optional: Rounded corners
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .stretch, // Make the column fill width
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Space between items
                            children: [
                              Text(
                                '${plan['label']}'.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              widget.selectedPlan == plan['name']
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                    )
                                  : const Text(''),
                            ],
                          ),
                          const SizedBox(height: 8), // Spacing between lines
                          Text(
                            plan['priceLabel'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
        const SizedBox(
          height: 32,
        ),
        PrimaryButton(
          text: 'Continuer',
          onPressed: (context) {
            Provider.of<SubscriptionProvider>(context, listen: false)
                .setStep('details');
          },
        ),
      ],
    );
  }
}
