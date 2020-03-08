class PaymentMethod {
  String cardHolderName;
  String cardNumber;
  String expireDate;
  String cvv;

  
  PaymentMethod() {
    this.cardHolderName = '';
    this.cardNumber = '';
    this.expireDate = '';
    this.cvv = '';
  }
  
  PaymentMethod.fromDetails(
    this.cardHolderName,
    this.cardNumber,
    this.expireDate,
    this.cvv,
  );

    toJson() {
      return {
        'cardHolderName': cardHolderName,
        'cardNumber': cardNumber,
        'expireDate': expireDate,
        'cvv': cvv,
      };
  }
}