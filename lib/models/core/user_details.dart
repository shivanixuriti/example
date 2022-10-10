class UserDetails {
  User? user;
  String? token;
  // String? status;

  UserDetails({this.user});

  UserDetails.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token= json['token'];
    // status= json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? email;
  String? password;
  String? mobileNumber;
  String? gid;
  String? referralCode;
  String? firstName;
  String? lastName;
  String? userRole;
  String? profilePic;
  String? status;
  bool? active;
  bool? softDelete;
  bool? flag;
  String? createdAt;
  String? updatedAt;
  // int? iV;

  User(
      {this.sId,
        this.name,
        this.email,
        this.password,
        this.mobileNumber,
        this.gid,
        this.referralCode,
        this.firstName,
        this.lastName,
        this.userRole,
        this.profilePic,
        this.status,
        this.active,
        this.softDelete,
        this.flag,
        this.createdAt,
        this.updatedAt,
        // this.iV
      });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    mobileNumber = json['mobile_number'];
    gid = json['gid'];
    referralCode = json['referral_code'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userRole = json['user_role'];
    profilePic = json['profile_pic'];
    status = json['status'];
    active = json['active'];
    softDelete = json['soft_delete'];
    flag = json['flag'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    // iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobile_number'] = this.mobileNumber;
    data['gid'] = this.gid;
    data['referral_code'] = this.referralCode;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['user_role'] = this.userRole;
    data['profile_pic'] = this.profilePic;
    data['status'] = this.status;
    data['active'] = this.active;
    data['soft_delete'] = this.softDelete;
    data['flag'] = this.flag;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    // data['__v'] = this.iV;
    return data;
  }
}
