import 'package:ebom/src/components/header/big_header.dart';
import 'package:ebom/src/components/list/custom_list_row.dart';
import 'package:ebom/src/components/products/product_label.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/products/product_details_screen.dart';
import 'package:ebom/src/services/cache_service.dart';
import 'package:ebom/src/services/product_service.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
final String keyword;
const ProductsScreen({this.keyword = '', super.key});

@override
State<ProductsScreen> createState() => \_ProductsScreenState();
}

class \_ProductsScreenState extends State<ProductsScreen> {
final ProductService service = ProductService(cacheService: CacheService());

List<dynamic> products = [];

final TextEditingController \_searchController = TextEditingController();
bool isLoading = false;

@override
void initState() {
super.initState();

    service.items((items) {
      setState(() {
        products = items;
      });
    }).then((items) {
      setState(() {
        products = items;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // String searchKeyword =
      //     Provider.of<SearchProvider>(context, listen: false).keyword;

      // if (searchKeyword != '') {
      //   setState(() {
      //     products = service.search(searchKeyword);
      //     _searchController.text = searchKeyword;
      //   });
      //   Provider.of<SearchProvider>(context, listen: false).setKeyword('');
      // }

      int categoryId =
          Provider.of<SearchProvider>(context, listen: false).categoryId;

      if (categoryId != 0) {
        searchByCategory(categoryId);
        Provider.of<SearchProvider>(context, listen: false).setCategoryId(0);
      }
    });

}

@override
void dispose() {
// Dispose the controller when the widget is removed
\_searchController.dispose();
super.dispose();
}

void search() {
service.search(\_searchController.text, (items) {
setState(() {
products = items;
});
}).then((items) {
setState(() {
products = items;
});
});
}

void searchByCategory(int categoryId) {
service.searchByCategory(categoryId, (items) {
setState(() {
products = items;
});
}).then((items) => {products = items});
}

@override
Widget build(BuildContext context) {
double width = MediaQuery.of(context).size.width;
double widthReference = 400;

    double imageHeight =
        width < widthReference ? 120 : 120 + (width - widthReference) * 0.1;

    // Adjust child aspect ratio based on screen size

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              BigHeader(
                title: 'Produits',
                searchPlaceholder: 'Entrer un mot cle',
                searchController: _searchController,
                onSearch: search,
                searchLoading: isLoading,
                screen: 'products_screen',
                onFilter: (int value) {
                  print("search by category");
                  searchByCategory(value);
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child:
                ),
              ),
            ],
          ),
        ),
      ),
    );

}
}

import 'dart:async';
import 'dart:convert';
import 'package:ebom/src/config/app_api.dart';
import 'package:ebom/src/services/cache_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
final CacheService cacheService;
final String baseUrl;

ProductService({required this.cacheService, this.baseUrl = AppApi.data});

Future<List<dynamic>> makeFuture(data) {
final completer = Completer<List<dynamic>>();
completer.complete(data);
return completer.future;
}

// Method to get all product categories using Completer
Future<List<dynamic>> items() async {
final completer = Completer<List<dynamic>>();

    final url = '$baseUrl/produits';

    dynamic cachedData;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(url);
    if (jsonString != null) {
      cachedData = jsonDecode(jsonString);
    }

    // Return cached data first
    if (cachedData != null) {
      // Load in the background.
      http.get(Uri.parse(url)).then((response) {
        if (response.statusCode == 200) {
          final res = json.decode(response.body);
          cacheService.saveToCache(url, res['data']);
          // Callback to update with new data.
          callback(res['data']);
        }
      });

      List<dynamic> list = [];
      for (int i = 0; i < cachedData.length; i++) {
        list.add(cachedData[i]);
      }

      completer.complete(list);

      // Return cache data.
      return completer.future;
    } else {
      // There is no cache data. Then fetch the data.
      http.get(Uri.parse(url)).then((response) {
        if (response.statusCode == 200) {
          final res = json.decode(response.body);

          cacheService.saveToCache(url, res['data']);

          // Return the result.
          completer.complete(res['data']);
        } else {
          completer.completeError('Failed to load product categories');
        }
      }).catchError((error) {
        completer.completeError(error.toString());
      });
    }

    return completer.future;

}

Future<List<dynamic>> dynamicItems(String apiUri, callback) async {
final completer = Completer<List<dynamic>>();

    String url = '$baseUrl/$apiUri';

    dynamic cachedData = await cacheService.getFromCache(url);

    if (cachedData != null) {
      http.get(Uri.parse('$baseUrl/$apiUri')).then((response) {
        if (response.statusCode == 200) {
          final res = json.decode(response.body);
          cacheService.saveToCache(url, res['data']);
          callback(makeFuture(res['data']));
        }
      });

      List<dynamic> list = [];
      for (int i = 0; i < cachedData.length; i++) {
        list.add(cachedData[i]);
      }
      completer.complete(list);

      // Return cache data.
      return completer.future;
    } else {
      http.get(Uri.parse('$baseUrl/$apiUri')).then((response) {
        if (response.statusCode == 200) {
          final res = json.decode(response.body);

          cacheService.saveToCache(url, res['data']);

          completer.complete(res['data']);
        } else {
          completer.completeError('Failed to load product categories');
        }
      }).catchError((error) {
        completer.completeError(error.toString());
      });
    }

    return completer.future;

}

Future<List<dynamic>> search(String keyword, callback) async {
final completer = Completer<List<dynamic>>();

    String url = AppApi.search;

    // Get cache data.
    dynamic cachedData = await cacheService.getFromCache('$url$keyword');

    if (cachedData != null) {
      // Load in the background.
      http
          .post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {'search': keyword},
        ),
      )
          .then((response) {
        if (response.statusCode == 200) {
          final res = json.decode(response.body);
          callback(res['data']['produits']);
        }
      });

      // Return cache.
      List<dynamic> list = [];
      for (int i = 0; i < cachedData.length; i++) {
        list.add(cachedData[i]);
      }
      completer.complete(list);
      return completer.future;
    } else {
      // Initial request
      http
          .post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {'search': keyword},
        ),
      )
          .then((response) {
        if (response.statusCode == 200) {
          final res = json.decode(response.body);

          // Save to cache.
          cacheService.saveToCache(url, res['data']['produits']);

          completer.complete(res['data']['produits']);
        } else {
          completer.complete([]);
        }
      }).catchError((error) {
        completer.complete([]);
      });

      return completer.future;
    }

}

Future<List<dynamic>> searchByCategory(int id, callback) async {
final completer = Completer<List<dynamic>>();
String url = '$baseUrl/produits/categorie/$id';

    // Get cache data.
    dynamic cachedData = await cacheService.getFromCache(url);

    print("seach by category");

    if (cachedData != null) {
      // Load in  background.
      http.get(Uri.parse(url)).then((response) {
        if (response.statusCode == 200) {
          final res = json.decode(response.body);
          callback(res['data']);
        }
      });

      // Return cache.
      List<dynamic> list = [];
      for (int i = 0; i < cachedData.length; i++) {
        list.add(cachedData[i]);
      }
      completer.complete(list);
      return completer.future;
    } else {
      // Load the initial request.
      http.get(Uri.parse(url)).then((response) {
        if (response.statusCode == 200) {
          final res = json.decode(response.body);

          // Save to cache.
          cacheService.saveToCache(url, res['data']);

          completer.complete(res['data']);
        } else {
          completer.complete([]);
        }
      }).catchError((error) {
        completer.complete([]);
      });

      return completer.future;
    }

}
}
