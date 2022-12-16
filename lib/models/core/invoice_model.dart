class Invoices {
  List<Invoice>? invoice;
  bool? status;

  Invoices({this.invoice, this.status});

  Invoices.fromJson(Map<String, dynamic> json) {
    if (json['invoice'] != null) {
      invoice = <Invoice>[];
      json['invoice'].forEach((v) {
        invoice!.add(new Invoice.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.invoice != null) {
      data['invoice'] = this.invoice!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Invoice {
  BillDetails? billDetails;
  String? sId;
  String? outstandingAmount;
  List<String>? itemizedData;
  String? invoiceStatus;
  // String? extraCreditFlag;
  String? invoiceFile;
  bool? emandateRaised;
  String? invoiceNumber;
  String? createdAt;
  String? updatedAt;
  // int? iV;
  Buyer? buyer;
  String? buyerGst;
  String? invoiceAmount;
  String? invoiceDate;
  String? invoiceDueDate;
  String? invoiceType;
  Buyer? seller;
  String? sellerGst;

  Invoice(
      {this.billDetails,
      this.sId,
      this.outstandingAmount,
      this.itemizedData,
      this.invoiceStatus,
      // this.extraCreditFlag,
      this.invoiceFile,
      this.emandateRaised,
      this.invoiceNumber,
      this.createdAt,
      this.updatedAt,
      // this.iV,
      this.buyer,
      this.buyerGst,
      this.invoiceAmount,
      this.invoiceDate,
      this.invoiceDueDate,
      this.invoiceType,
      this.seller,
      this.sellerGst});

  Invoice.fromJson(Map<String, dynamic> json) {
    billDetails = json['bill_details'] != null
        ? BillDetails.fromJson(json['bill_details'])
        : null;
    sId = json['_id'];
    outstandingAmount = json['outstanding_amount'].toString();
    itemizedData = (json['itemized_data'] == null)
        ? json['itemized_data']
        : json['itemized_data'].cast<String>();
    invoiceStatus = json['invoice_status'];
    // extraCreditFlag = json['extra_credit_flag'];
    invoiceFile = json['invoice_file'];
    emandateRaised = json['emandate_raised'];
    invoiceNumber = json['invoice_number'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    buyer = json['buyer'] != null ? new Buyer.fromJson(json['buyer']) : null;
    buyerGst = json['buyer_gst'];
    invoiceAmount = json['invoice_amount'];
    invoiceDate = json['invoice_date'];
    invoiceDueDate = json['invoice_due_date'];
    invoiceType = json['invoice_type'];
    seller = json['seller'] != null ? new Buyer.fromJson(json['seller']) : null;
    sellerGst = json['seller_gst'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['outstanding_amount'] = this.outstandingAmount;
    data['itemized_data'] = this.itemizedData;
    data['invoice_status'] = this.invoiceStatus;
    // data['extra_credit_flag'] = this.extraCreditFlag;
    data['invoice_file'] = this.invoiceFile;
    data['emandate_raised'] = this.emandateRaised;
    data['invoice_number'] = this.invoiceNumber;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    // data['__v'] = this.iV;
    if (this.buyer != null) {
      data['buyer'] = this.buyer!.toJson();
    }
    data['buyer_gst'] = this.buyerGst;
    data['invoice_amount'] = this.invoiceAmount;
    data['invoice_date'] = this.invoiceDate;
    data['invoice_due_date'] = this.invoiceDueDate;
    data['invoice_type'] = this.invoiceType;
    if (this.seller != null) {
      data['seller'] = this.seller!.toJson();
    }
    data['seller_gst'] = this.sellerGst;
    return data;
  }
}

class BillDetails {
  GstSummary? gstSummary;
  DiscountSummary? discountSummary;
  TaxSummary? taxSummary;

  BillDetails({this.gstSummary, this.discountSummary, this.taxSummary});

  BillDetails.fromJson(Map<String, dynamic> json) {
    gstSummary = json['gst_summary'] != null
        ? new GstSummary.fromJson(json['gst_summary'])
        : null;
    discountSummary = json['discount_summary'] != null
        ? new DiscountSummary.fromJson(json['discount_summary'])
        : null;
    taxSummary = json['tax_summary'] != null
        ? new TaxSummary.fromJson(json['tax_summary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gstSummary != null) {
      data['gst_summary'] = this.gstSummary!.toJson();
    }
    if (this.discountSummary != null) {
      data['discount_summary'] = this.discountSummary!.toJson();
    }
    if (this.taxSummary != null) {
      data['tax_summary'] = this.taxSummary!.toJson();
    }
    return data;
  }
}

class GstSummary {
  String? cgst;
  String? sgst;
  String? igst;
  String? totalTax;

  GstSummary({this.cgst, this.sgst, this.igst, this.totalTax});

  GstSummary.fromJson(Map<String, dynamic> json) {
    cgst = json['cgst'];
    sgst = json['sgst'];
    igst = json['igst'];
    totalTax = json['total_tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cgst'] = this.cgst;
    data['sgst'] = this.sgst;
    data['igst'] = this.igst;
    data['total_tax'] = this.totalTax;
    return data;
  }
}

class DiscountSummary {
  String? cashDiscount;
  String? specialDiscount;
  String? inBillDiscount;
  String? totalDiscount;

  DiscountSummary(
      {this.cashDiscount,
      this.specialDiscount,
      this.inBillDiscount,
      this.totalDiscount});

  DiscountSummary.fromJson(Map<String, dynamic> json) {
    cashDiscount = json['cash_discount'];
    specialDiscount = json['special_discount'];
    inBillDiscount = json['in_bill_discount'];
    totalDiscount = json['total_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cash_discount'] = this.cashDiscount;
    data['special_discount'] = this.specialDiscount;
    data['in_bill_discount'] = this.inBillDiscount;
    data['total_discount'] = this.totalDiscount;
    return data;
  }
}

class TaxSummary {
  String? tcsBasedValue;
  String? tcsTaxValue;

  TaxSummary({this.tcsBasedValue, this.tcsTaxValue});

  TaxSummary.fromJson(Map<String, dynamic> json) {
    tcsBasedValue = json['tcs_based_value'];
    tcsTaxValue = json['tcs_tax_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tcs_based_value'] = this.tcsBasedValue;
    data['tcs_tax_value'] = this.tcsTaxValue;
    return data;
  }
}

class Buyer {
  String? sId;
  String? gstin;
  String? companyName;
  String? address;
  String? district;
  String? state;
  String? pincode;
  int? companyMobile;
  String? companyEmail;
  String? pan;
  String? cin;
  String? tan;
  String? status;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  String? adminMobile;
  String? adminEmail;
  String? adminName;
  String? creditLimit;
  String? availCredit;
  // String? optimizecredit;
  // int? iV;
  String? presignedurl;
  String? annualTurnover;
  String? industryType;
  String? interest;

  Buyer(
      {this.sId,
      this.gstin,
      this.companyName,
      this.address,
      this.district,
      this.state,
      this.pincode,
      this.companyMobile,
      this.companyEmail,
      this.pan,
      this.cin,
      this.tan,
      this.status,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.adminMobile,
      this.adminEmail,
      this.adminName,
      this.creditLimit,
      this.availCredit,
      // this.optimizecredit,
      // this.iV,
      this.presignedurl,
      this.annualTurnover,
      this.industryType,
      this.interest});

  Buyer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    gstin = json['gstin'];
    companyName = json['company_name'];
    address = json['address'];
    district = json['district'];
    state = json['state'];
    pincode = json['pincode'].toString();
    companyMobile = json['company_mobile'];
    companyEmail = json['company_email'];
    pan = json['pan'];
    cin = json['cin'];
    tan = json['tan'];
    status = json['status'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    adminMobile = json['admin_mobile'];
    adminEmail = json['admin_email'];
    adminName = json['admin_name'];
    json['creditLimit'] == null
        ? ""
        : creditLimit = json['creditLimit'].toString();
    json['avail_credit'] == null
        ? ""
        : availCredit = json['avail_credit'].toString();
    // json['optimizecredit'] == null ? "" :
    // optimizecredit = json['optimizecredit'].toString();
    // iV = json['__v'];
    presignedurl = json['presignedurl'];
    annualTurnover = json['annual_turnover'];
    industryType = json['industry_type'];
    interest = json['interest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['gstin'] = this.gstin;
    data['company_name'] = this.companyName;
    data['address'] = this.address;
    data['district'] = this.district;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['company_mobile'] = this.companyMobile;
    data['company_email'] = this.companyEmail;
    data['pan'] = this.pan;
    data['cin'] = this.cin;
    data['tan'] = this.tan;
    data['status'] = this.status;
    data['createdBy'] = this.createdBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['admin_mobile'] = this.adminMobile;
    data['admin_email'] = this.adminEmail;
    data['admin_name'] = this.adminName;
    data['creditLimit'] = this.creditLimit;
    data['avail_credit'] = this.availCredit;
    // data['optimizecredit'] = this.optimizecredit;
    // data['__v'] = this.iV;
    data['presignedurl'] = this.presignedurl;
    data['annual_turnover'] = this.annualTurnover;
    data['industry_type'] = this.industryType;
    data['interest'] = this.interest;
    return data;
  }
}
