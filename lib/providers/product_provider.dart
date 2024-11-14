import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier {

  int _selectMenu = 0;
  int get selectMenu => _selectMenu;

  updateSelectMenu(int selectMenu) {
    _selectMenu = selectMenu;
    _lastDocsnap = null;
    notifyListeners();
  }

  var _searchText;
  get searchText => _searchText;

  updateSearchText(searchText) {
    _searchText = searchText;
    notifyListeners();
  }

  var _lastDocsnap;
  get lastDocsnap => _lastDocsnap;

  updateLastDocsnap(lastDocsnap) {
    _lastDocsnap = lastDocsnap;
    notifyListeners();
  }
}