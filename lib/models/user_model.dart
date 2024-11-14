class UserClass {
  // 회워가입시 내용들
  var uid;
  var phoneNumber;
  var nickName;
  var point;  // number
  var address;
  var detailAddress;
  var account;
  var bank;
  var email;
  var pw;

  UserClass(
      {
        this.uid,
        this.phoneNumber,
        this.nickName,
        this.point,
        this.account,
        this.address,
        this.bank,
        this.detailAddress,
        this.email,
        this.pw,
      });

  returnUserClass({required userMap}) {
    return UserClass(
      uid: userMap['uid'],
      phoneNumber: userMap['phoneNumber'],
      nickName: userMap['nickName'],
      point: userMap['point'],
      account: userMap['account'],
      address: userMap['address'],
      bank: userMap['bank'],
      detailAddress: userMap['detailAddress'],
      email: userMap['email'],
      pw: userMap['pw'],
    );
  }
}
