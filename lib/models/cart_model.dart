class CartClass {
  var num;
  var productId;
  var time;

  CartClass(
      {
        this.num,
        this.time,
        this.productId,
      });

  returnCartClass({required dataMap}) {
    return CartClass(
      num: dataMap['num'],
      time: dataMap['time'],
      productId: dataMap['productId'],
    );
  }
}
