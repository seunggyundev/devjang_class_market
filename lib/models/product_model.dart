class ProductClass {
  var amount;
  var category;
  var docId;
  var downloadUrl;
  var time;
  var title;
  var searchParamsTitleList;

  ProductClass(
      {
        this.amount,
        this.category,
        this.docId,
        this.downloadUrl,
        this.time,
        this.title,
        this.searchParamsTitleList
      });

  returnProductClass({required dataMap}) {
    return ProductClass(
      amount: dataMap['amount'],
      category: dataMap['category'],
      docId: dataMap['docId'],
      downloadUrl: dataMap['downloadUrl'],
      time: dataMap['time'],
      title: dataMap['title'],
        searchParamsTitleList: dataMap['searchParamsTitleList'],
    );
  }
}
