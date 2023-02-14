class TransactionModel {
  bool? status;
  List<Transaction>? transaction;

  TransactionModel({this.status, this.transaction});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction!.add(new Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transaction {
  String? account;
  String? accountType;
  String? invoiceId;
  String? transactionType;
  double? transactionAmount;
  String? counterParty;
  double? balance;
  String? recordType;
  String? createdAt;

  Transaction(
      {this.account,
      this.accountType,
      this.invoiceId,
      this.transactionType,
      this.transactionAmount,
      this.counterParty,
      this.balance,
      this.recordType,
      this.createdAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    accountType = json['account_type'];
    invoiceId = json['invoice_id'];
    transactionType = json['transaction_type'];
    transactionAmount = json['transaction_amount'];
    counterParty = json['counter_party'];
    balance = json['balance'];
    recordType = json['record_type'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['account_type'] = this.accountType;
    data['invoice_id'] = this.invoiceId;
    data['transaction_type'] = this.transactionType;
    data['transaction_amount'] = this.transactionAmount;
    data['counter_party'] = this.counterParty;
    data['balance'] = this.balance;
    data['record_type'] = this.recordType;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
