import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/services/auth_service.dart';
import 'package:ebom/src/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<Subscription> _ongoing = [];
  SubscriptionService subscriptionService = SubscriptionService();
  AuthService authService = AuthService();
  bool _loading = true;

  Map<String, String> forfaits = {
    'jour': 'Forfait Jour',
    'semaine': 'Forfait Semaine',
    'mois': 'Forfait mois',
    'annee': 'Forfat annee',
  };

  @override
  void initState() {
    super.initState();

    // Get devise id.
    authService.getDeviseId(context).then((deviseId) {
      // load ongoing subscriptions
      subscriptionService.items().then((serviceAbonnements) {
        subscriptionService.ongoing(deviseId).then((values) {
          // Restructure ongoing

          List<Subscription> list = [];

          for (int i = 0; i < values.length; i++) {
            String service = '';

            for (int j = 0; j < serviceAbonnements.length; j++) {
              if (serviceAbonnements[j]['id'] ==
                  values[i]['service_abonnement']) {
                service = serviceAbonnements[j]['nom'];
              }
            }

            String dureeDetails =
                values[i]['duree'] > 1 && values[i]['periode'] != 'mois'
                    ? '${values[i]['duree']} ${values[i]['periode']}s'
                    : '${values[i]['duree']} ${values[i]['periode']}';

            Subscription item = Subscription(
              id: values[i]['id'],
              reference: values[i]['reference'],
              serviceAbonnement: values[i]['service_abonnement'],
              transactionId: values[i]['transaction_id'],
              periode: values[i]['periode'],
              duree: values[i]['duree'],
              dateDebut: values[i]['date_debut'],
              dateFin: values[i]['date_fin'],
              service: service,
              forfait: forfaits[values[i]['periode']]!,
              dureeDetails: dureeDetails,
            );
            list.add(item);
          }

          setState(() {
            _ongoing = list;
            _loading = false;
          });
        }).catchError((error) {
          _ongoing = [];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Mes abonnements',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: _loading
          ? subscriptionsSkeleton()
          : ListView.builder(
              itemCount: _ongoing.length, // Number of ongoing to generate
              itemBuilder: (context, index) {
                Subscription item = _ongoing[index];

                return Container(
                  margin: EdgeInsets.only(
                    top: index == 0 ? 24 : 0,
                    bottom: 12,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.service,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.forfait,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Durée : ${item.dureeDetails}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Valide jusqu'à la date du ${item.dateFin}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gray700,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

Widget subscriptionsSkeleton() {
  return ListView.builder(
    itemCount: 5, // Number of skeleton items to display
    itemBuilder: (context, index) {
      return Container(
        margin: EdgeInsets.only(
          top: index == 0 ? 24 : 0,
          bottom: 12,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 14,
                width: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              Container(
                height: 14,
                width: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              Container(
                height: 14,
                width: 120,
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              Container(
                height: 14,
                width: 180,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}
