import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';
import 'make_search_param.dart';

class ProductService {

  Future makeAllProductSearchList() async {
    try {
      var res = await FirebaseFirestore.instance.collection('Product').get();
      if (res.docs.isNotEmpty) {
        List resList = res.docs;
        for (int i = 0; i < resList.length; i++) {
          var dataMap = resList[i].data();
          ProductClass productClass = ProductClass().returnProductClass(dataMap: dataMap);

          List<String> _searchParamsTitleList = MakeSearchParam().setSearchParam(productClass.title ?? '');
          print('$i 번째 ${_searchParamsTitleList} / ${productClass.docId}');
          try {
            await FirebaseFirestore.instance.collection('Product').doc('${productClass.docId}').update({
              'searchParamsTitleList': _searchParamsTitleList,
            });
          } catch(e) {
            print('$i 번째 업데이트 오류 ${e}  /  ${productClass.docId}  ${productClass.title}');
          }
          print('$i 번째 업데이트 완료');
        }
        print('종료');
        return;
      }
    } catch(e) {
      print('error makeAllProductSearchList $e');
    }
  }

  Future<List> getProductList({required ProductProvider productProvider}) async {
    try {
      var query;
      query = FirebaseFirestore.instance.collection('Product');

      if (productProvider.searchText != null && productProvider.searchText.toString().isNotEmpty) {
        if (productProvider.selectMenu == 0) {
          query = query
              .where('searchParamsTitleList', arrayContains: productProvider.searchText);
        } else {
          query = query.where('category', isEqualTo: productProvider.selectMenu)
              .where('searchParamsTitleList', arrayContains: productProvider.searchText);
        }
      } else {
        if (productProvider.selectMenu == 0) {
          query = query;
        } else {
          query = query.where('category', isEqualTo: productProvider.selectMenu);
        }
      }

      var res;

      if (productProvider.lastDocsnap == null) {
        res = await query.orderBy('time', descending: true).limit(15).get();
      } else {
        res = await query.orderBy('time', descending: true).startAfterDocument(productProvider.lastDocsnap).limit(15).get();
      }

      List<ProductClass> returnList = [];

      if (res.docs.isNotEmpty) {
        List resList = res.docs;
        for (int i = 0; i < resList.length; i++) {
          var data = resList[i];
          var dataMap = data.data();
          returnList.add(ProductClass().returnProductClass(dataMap: dataMap));

          if (i == resList.length - 1) {
            productProvider.updateLastDocsnap(data);
          }
        }
      }

      return [true, returnList];
    } catch(e) {
      print('error getProductList $e');
      return [false, e.toString()];
    }
  }

  Future<List> insertToCart({required productId, required uid,}) async {
    try {
      var res = await FirebaseFirestore.instance.collection('userCol').doc('${uid}').collection('cart').doc('$productId').get();
      bool isExist = false;

      if (res.exists) {
        var resMap = res.data();
        if (resMap != null) {
          isExist = true;
          int num = resMap['num'] + 1;
          await FirebaseFirestore.instance.collection('userCol').doc('$uid').collection('cart').doc('$productId').update(
              {
                'num': num,
              });
          return [true];
        }
      }

      if (!isExist) {
        await FirebaseFirestore.instance.collection('userCol').doc('$uid').collection('cart').doc('$productId').set(
            {
              'productId': productId,
              'num': 0,
              'time': Timestamp.now(),
            });
        return [true];
      }
    } catch(e) {
      print('error insertToCart ${e}');
      return [false, e.toString()];
    }
  }

  Future<List> getCartData({required uid}) async {
    var data = await FirebaseFirestore.instance.collection('userCol').doc('${uid}').collection('cart').get();
    List dataList = data.docs;

    return dataList;
  }

  Future getProductData({required productId}) async {
    var data = await FirebaseFirestore.instance.collection('Product').doc('${productId}').get();

    return data.data();
  }

  Future<void> minusNumCartProduct({required uid, required productId}) async {
    try {
      var res = await FirebaseFirestore.instance.collection('userCol').doc('${uid}').collection('cart').doc('$productId').get();
      if (res.exists) {
        var resMap = res.data();
        if (resMap != null) {
          int num = (resMap['num'] - 1) < 0 ? 0 : resMap['num'] - 1;

          await FirebaseFirestore.instance.collection('userCol').doc('$uid').collection('cart').doc('$productId').update(
              {
                'num': num,
              });
        }
      }
    } catch(e) {
      print('error minusNumCartProduct ${e}');
    }
  }

  Future<void> plusNumCartProduct({required uid, required productId}) async {
    try {
      var res = await FirebaseFirestore.instance.collection('userCol').doc('${uid}').collection('cart').doc('$productId').get();
      if (res.exists) {
        var resMap = res.data();
        if (resMap != null) {
          int num = resMap['num'] + 1;

          await FirebaseFirestore.instance.collection('userCol').doc('$uid').collection('cart').doc('$productId').update(
              {
                'num': num,
              });
        }
      }
    } catch(e) {
      print('error minusNumCartProduct ${e}');
    }
  }

  Future<void> removeCartProduct({required uid, required productId}) async {
    await  FirebaseFirestore.instance.collection('userCol').doc('${uid}').collection('cart').doc('$productId').delete();
  }
}