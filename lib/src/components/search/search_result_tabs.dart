import 'package:flutter/material.dart';

import 'package:ebom/src/components/search/search_types_chip.dart';
import 'package:ebom/src/components/skeleton/search_result_skeleton.dart';
import 'package:ebom/src/screens/home_screen/entreprise_result_item.dart';
import 'package:ebom/src/screens/home_screen/product_result_item.dart';
import 'package:ebom/src/screens/home_screen/service_result_item.dart';
import 'package:ebom/src/services/search_service.dart';

class SearchResultTabs extends StatefulWidget {
  final Future<List<ResultItem>> results;

  const SearchResultTabs({
    super.key,
    required this.results,
  });

  @override
  State<SearchResultTabs> createState() => _SearchResultTabsState();
}

class _SearchResultTabsState extends State<SearchResultTabs> {
  String selectedType = 'Tous';

  List<ResultItem>? _items;
  late final Map<String, List<ResultItem>> _groupedItems;

  @override
  void initState() {
    super.initState();

    widget.results.then((data) {
      if (!mounted) return;
      setState(() {
        _items = data;
        _groupedItems = _groupByType(data);
      });
    });
  }

  Map<String, List<ResultItem>> _groupByType(List<ResultItem> items) {
    final Map<String, List<ResultItem>> grouped = {};
    for (final item in items) {
      grouped.putIfAbsent(item.type, () => []).add(item);
    }
    return grouped;
  }

  int _currentIndex() {
    switch (selectedType) {
      case 'Produit':
        return 1;
      case 'Service':
        return 2;
      case 'Entreprise':
        return 3;
      default:
        return 0; // Tous
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 🔹 Loading
    if (_items == null) {
      return Column(
        children: List.generate(
          10,
          (_) => Padding(
            padding: EdgeInsets.all(16),
            child: SearchResultSkeleton(),
          ),
        ),
      );
    }

    /// 🔹 Aucun résultat
    if (_items!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Aucun résultat'),
      );
    }

    final types = ['Tous', ..._groupedItems.keys];

    return Column(
      children: [
        /// 🔹 Tabs
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: types.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final type = types[index];

              return SearchTypesChip(
                label: type,
                isSelected: selectedType == type,
                onTap: () {
                  setState(() => selectedType = type);
                },
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        /// 🔹 Résultats (instantané)
        IndexedStack(
          index: _currentIndex(),
          children: [
            /// 🔹 TOUS
            Column(
              children: [
                ...?_groupedItems['Produit']
                    ?.asMap()
                    .entries
                    .map(
                      (e) => ProductResultItem(
                        key: ValueKey('p-${e.value.data['id']}'),
                        index: e.key,
                        item: e.value,
                      ),
                    ),
                ...?_groupedItems['Service']
                    ?.asMap()
                    .entries
                    .map(
                      (e) => ServiceResultItem(
                        key: ValueKey('s-${e.value.data['id']}'),
                        index: e.key,
                        item: e.value,
                      ),
                    ),
                ...?_groupedItems['Entreprise']
                    ?.asMap()
                    .entries
                    .map(
                      (e) => EntrepriseResultItem(
                        key: ValueKey('e-${e.value.data['id']}'),
                        index: e.key,
                        item: e.value,
                      ),
                    ),
              ],
            ),

            /// 🔹 PRODUITS
            Column(
              children: List.generate(
                _groupedItems['Produit']?.length ?? 0,
                (i) => ProductResultItem(
                  key: ValueKey('p-${_groupedItems['Produit']![i].data['id']}'),
                  index: i,
                  item: _groupedItems['Produit']![i],
                ),
              ),
            ),

            /// 🔹 SERVICES
            Column(
              children: List.generate(
                _groupedItems['Service']?.length ?? 0,
                (i) => ServiceResultItem(
                  key: ValueKey('s-${_groupedItems['Service']![i].data['id']}'),
                  index: i,
                  item: _groupedItems['Service']![i],
                ),
              ),
            ),

            /// 🔹 ENTREPRISES
            Column(
              children: List.generate(
                _groupedItems['Entreprise']?.length ?? 0,
                (i) => EntrepriseResultItem(
                  key: ValueKey('e-${_groupedItems['Entreprise']![i].data['id']}'),
                  index: i,
                  item: _groupedItems['Entreprise']![i],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
