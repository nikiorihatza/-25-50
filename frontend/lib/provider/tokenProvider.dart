import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../func/httpFunc.dart';

class TokenProvider with ChangeNotifier {
  String? _apiToken;
  bool _isLoading = true;

  String? get apiToken => _apiToken;
  bool get isLoading => _isLoading;

  TokenProvider() {
    initializeProvider();
  }

  initializeProvider() async {
    _apiToken = await HTTPFunc().fetchApiToken();
    _isLoading = false;
    notifyListeners();
  }
}
