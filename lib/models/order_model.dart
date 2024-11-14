class OrderClass {
  var uid;
  var orderId;
  var time;

  var address;
  var detailAddress;
  var photoPathList; // list
  var phoneNumber;
  var sumPrice;
  var selectTime;
  var productList;
  var numMap;
  var kakaoLongitude;
  var kakaoLatitude;


  OrderClass(
  {
    this.uid,
    this.phoneNumber,
    this.detailAddress,
    this.address,
    this.time,
    this.orderId,
    this.photoPathList,
    this.sumPrice,
    this.selectTime,
    this.productList,
    this.numMap,
    this.kakaoLongitude,
    this.kakaoLatitude,
  }
      );

  OrderClass returnOrderClass({required dataMap}) {
    return OrderClass(
      uid: dataMap['uid'],
      phoneNumber: dataMap['phoneNumber'],
      detailAddress: dataMap['detailAddress'],
      address: dataMap['address'],
      time: dataMap['time'],
      orderId: dataMap['orderId'],
      photoPathList: dataMap['photoPathList'],
        sumPrice: dataMap['sumPrice'],
        selectTime: dataMap['selectTime'],
        productList: dataMap['productList'],
        numMap: dataMap['numMap'],
        kakaoLongitude: dataMap['kakaoLongitude'],
        kakaoLatitude: dataMap['kakaoLatitude'],

    );
  }
}