class LoginModel {
  bool? status;
  String? message;
  Data? data;
  String? token;

  List<Secretkey>? secretkey;

  LoginModel(
      {this.status, this.message, this.data, this.token, this.secretkey});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    token = json['token'];
    if (json['secretkey'] != null) {
      secretkey = <Secretkey>[];
      json['secretkey'].forEach((v) {
        secretkey!.add(Secretkey.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = token;
    if (secretkey != null) {
      data['secretkey'] = secretkey!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  int? nsId;
  String? employeeCode;
  String? title;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? dateOfBirth;
  String? nationality;
  String? role;
  String? supervisor;
  String? linemanager;
  String? hod;
  String? subsidiary;
  String? subsidiaryId;
  String? department;
  String? weekoffcreteria;
  String? mobileemail;
  String? mobileusername;
  String? mobilepassword;
  bool? mobileaccess;
  String? source;
  int? syncStatus;
  String? firebaseTokenid;

  List<Contacts>? contacts;
  List<Documents>? documents;
  List<Skill>? skill;
  List<Qualification>? qualification;
  List<DependantDetails>? dependantDetails;
  List<DependantIdDetails>? dependantIdDetails;
  List<EmergencyContact>? emergencyContact;
  String? imageurl;
  String? imagename;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? mobileNo;
  String? workRegion;
  String? paygroupId;
  String? paygroupName;
  String? lineMangerID;
  Data(
      {this.sId,
      this.nsId,
      this.employeeCode,
      this.title,
      this.firstName,
      this.middleName,
      this.lastName,
      this.gender,
      this.dateOfBirth,
      this.nationality,
      this.role,
      this.supervisor,
      this.linemanager,
      this.hod,
      this.subsidiary,
      this.subsidiaryId,
      this.department,
      this.weekoffcreteria,
      this.mobileemail,
      this.mobileusername,
      this.mobilepassword,
      this.mobileaccess,
      this.source,
      this.syncStatus,
      this.firebaseTokenid,
      this.contacts,
      this.documents,
      this.skill,
      this.qualification,
      this.dependantDetails,
      this.dependantIdDetails,
      this.emergencyContact,
      this.imageurl,
      this.imagename,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.mobileNo,
      this.workRegion,
      this.paygroupId,
      this.paygroupName,
      this.lineMangerID});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nsId = json['nsId'];
    employeeCode = json['employeeCode'];
    title = json['title'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    nationality = json['nationality'];
    role = json['role'];
    supervisor = json['supervisor'];
    linemanager = json['linemanager'];
    hod = json['hod'];
    subsidiary = json['subsidiary'];
    subsidiaryId = json['subsidiaryId'];
    department = json['department'];
    weekoffcreteria = json['weekoffcreteria'];
    mobileemail = json['mobileemail'];
    mobileusername = json['mobileusername'];
    mobilepassword = json['mobilepassword'];
    mobileaccess = json['mobileaccess'];
    source = json['source'];
    syncStatus = json['syncStatus'];
    firebaseTokenid = json['firebaseTokenid'];
    if (json['contacts'] != null) {
      contacts = <Contacts>[];
      json['contacts'].forEach((v) {
        contacts!.add(Contacts.fromJson(v));
      });
    }
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
    if (json['skill'] != null) {
      skill = <Skill>[];
      json['skill'].forEach((v) {
        skill!.add(Skill.fromJson(v));
      });
    }
    if (json['qualification'] != null) {
      qualification = <Qualification>[];
      json['qualification'].forEach((v) {
        qualification!.add(Qualification.fromJson(v));
      });
    }
    if (json['dependantDetails'] != null) {
      dependantDetails = <DependantDetails>[];
      json['dependantDetails'].forEach((v) {
        dependantDetails!.add(DependantDetails.fromJson(v));
      });
    }
    if (json['dependantIdDetails'] != null) {
      dependantIdDetails = <DependantIdDetails>[];
      json['dependantIdDetails'].forEach((v) {
        dependantIdDetails!.add(DependantIdDetails.fromJson(v));
      });
    }
    if (json['emergencyContact'] != null) {
      emergencyContact = <EmergencyContact>[];
      json['emergencyContact'].forEach((v) {
        emergencyContact!.add(EmergencyContact.fromJson(v));
      });
    }
    imageurl = json['imageurl'];
    imagename = json['imagename'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    mobileNo = json['mobileNo'];
    workRegion = json['workRegion'];
    paygroupId = json['paygroupid'];
    paygroupName = json['paygroupname'];
    lineMangerID = json['lineManagerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['nsId'] = nsId;
    data['employeeCode'] = employeeCode;
    data['title'] = title;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['nationality'] = nationality;
    data['role'] = role;
    data['supervisor'] = supervisor;
    data['linemanager'] = linemanager;
    data['hod'] = hod;
    data['subsidiary'] = subsidiary;
    data['subsidiaryId'] = subsidiaryId;
    data['department'] = department;
    data['weekoffcreteria'] = weekoffcreteria;
    data['mobileemail'] = mobileemail;
    data['mobileusername'] = mobileusername;
    data['mobilepassword'] = mobilepassword;
    data['mobileaccess'] = mobileaccess;
    data['source'] = source;
    data['syncStatus'] = syncStatus;
    data['firebaseTokenid'] = firebaseTokenid;
    if (contacts != null) {
      data['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    if (skill != null) {
      data['skill'] = skill!.map((v) => v.toJson()).toList();
    }
    if (qualification != null) {
      data['qualification'] = qualification!.map((v) => v.toJson()).toList();
    }
    if (dependantDetails != null) {
      data['dependantDetails'] =
          dependantDetails!.map((v) => v.toJson()).toList();
    }
    if (dependantIdDetails != null) {
      data['dependantIdDetails'] =
          dependantIdDetails!.map((v) => v.toJson()).toList();
    }
    if (emergencyContact != null) {
      data['emergencyContact'] =
          emergencyContact!.map((v) => v.toJson()).toList();
    }
    data['imageurl'] = imageurl;
    data['imagename'] = imagename;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['mobileNo'] = mobileNo;
    data['paygroupid'] = paygroupId;
    data['paygroupname'] = paygroupName;
    data['lineManagerId'] = lineMangerID;
    return data;
  }
}

class Contacts {
  String? address;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? zipCode;
  String? phone;
  String? internalId;
  String? firstName;
  bool? defaultBilling;
  String? sId;

  Contacts(
      {this.address,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.country,
      this.zipCode,
      this.phone,
      this.internalId,
      this.firstName,
      this.defaultBilling,
      this.sId});

  Contacts.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipCode = json['zipCode'];
    phone = json['phone'];
    internalId = json['internalId'];
    firstName = json['firstName'];
    defaultBilling = json['defaultBilling'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['zipCode'] = zipCode;
    data['phone'] = phone;
    data['internalId'] = internalId;
    data['firstName'] = firstName;
    data['defaultBilling'] = defaultBilling;
    data['_id'] = sId;
    return data;
  }
}

class Documents {
  String? documentType;
  String? companyName;
  String? expiryDate;
  String? attachment;
  String? sId;

  Documents(
      {this.documentType,
      this.companyName,
      this.expiryDate,
      this.attachment,
      this.sId});

  Documents.fromJson(Map<String, dynamic> json) {
    documentType = json['documentType'];
    companyName = json['companyName'];
    expiryDate = json['expiryDate'];
    attachment = json['attachment'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentType'] = documentType;
    data['companyName'] = companyName;
    data['expiryDate'] = expiryDate;
    data['attachment'] = attachment;
    data['_id'] = sId;
    return data;
  }
}

class Skill {
  String? skillId;
  String? skillCode;
  String? skillName;
  String? skillCertificate;
  String? sId;

  Skill(
      {this.skillId,
      this.skillCode,
      this.skillName,
      this.skillCertificate,
      this.sId});

  Skill.fromJson(Map<String, dynamic> json) {
    skillId = json['skillId'];
    skillCode = json['skillCode'];
    skillName = json['skillName'];
    skillCertificate = json['skillCertificate'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skillId'] = skillId;
    data['skillCode'] = skillCode;
    data['skillName'] = skillName;
    data['skillCertificate'] = skillCertificate;
    data['_id'] = sId;
    return data;
  }
}

class Qualification {
  String? qualificationId;
  String? education;
  String? college;
  String? passingYear;
  String? percentage;
  String? certificate;
  String? sId;

  Qualification(
      {this.qualificationId,
      this.education,
      this.college,
      this.passingYear,
      this.percentage,
      this.certificate,
      this.sId});

  Qualification.fromJson(Map<String, dynamic> json) {
    qualificationId = json['qualificationId'];
    education = json['education'];
    college = json['college'];
    passingYear = json['passingYear'];
    percentage = json['percentage'];
    certificate = json['certificate'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qualificationId'] = qualificationId;
    data['education'] = education;
    data['college'] = college;
    data['passingYear'] = passingYear;
    data['percentage'] = percentage;
    data['certificate'] = certificate;
    data['_id'] = sId;
    return data;
  }
}

class DependantDetails {
  String? dependantName;
  String? dob;
  String? phoneNo;
  String? relationship;
  bool? insurance;
  bool? airTicket;
  String? address;
  bool? educationAllowance;
  String? sId;

  DependantDetails(
      {this.dependantName,
      this.dob,
      this.phoneNo,
      this.relationship,
      this.insurance,
      this.airTicket,
      this.address,
      this.educationAllowance,
      this.sId});

  DependantDetails.fromJson(Map<String, dynamic> json) {
    dependantName = json['dependantName'];
    dob = json['dob'];
    phoneNo = json['phoneNo'];
    relationship = json['relationship'];
    insurance = json['insurance'];
    airTicket = json['airTicket'];
    address = json['address'];
    educationAllowance = json['educationAllowance'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dependantName'] = dependantName;
    data['dob'] = dob;
    data['phoneNo'] = phoneNo;
    data['relationship'] = relationship;
    data['insurance'] = insurance;
    data['airTicket'] = airTicket;
    data['address'] = address;
    data['educationAllowance'] = educationAllowance;
    data['_id'] = sId;
    return data;
  }
}

class DependantIdDetails {
  String? dependantIdDetailsId;
  String? idType;
  String? idNo;
  String? dependantIdName;
  String? companyName;
  String? countryOfIssue;
  String? issueDate;
  String? expiryDate;
  String? designation;
  String? remarks;
  bool? remainder;
  String? remainderDate;
  String? attachment;
  String? sId;

  DependantIdDetails(
      {this.dependantIdDetailsId,
      this.idType,
      this.idNo,
      this.dependantIdName,
      this.companyName,
      this.countryOfIssue,
      this.issueDate,
      this.expiryDate,
      this.designation,
      this.remarks,
      this.remainder,
      this.remainderDate,
      this.attachment,
      this.sId});

  DependantIdDetails.fromJson(Map<String, dynamic> json) {
    dependantIdDetailsId = json['dependantIdDetailsId'];
    idType = json['idType'];
    idNo = json['idNo'];
    dependantIdName = json['dependantIdName'];
    companyName = json['companyName'];
    countryOfIssue = json['countryOfIssue'];
    issueDate = json['issueDate'];
    expiryDate = json['expiryDate'];
    designation = json['designation'];
    remarks = json['remarks'];
    remainder = json['remainder'];
    remainderDate = json['remainderDate'];
    attachment = json['attachment'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dependantIdDetailsId'] = dependantIdDetailsId;
    data['idType'] = idType;
    data['idNo'] = idNo;
    data['dependantIdName'] = dependantIdName;
    data['companyName'] = companyName;
    data['countryOfIssue'] = countryOfIssue;
    data['issueDate'] = issueDate;
    data['expiryDate'] = expiryDate;
    data['designation'] = designation;
    data['remarks'] = remarks;
    data['remainder'] = remainder;
    data['remainderDate'] = remainderDate;
    data['attachment'] = attachment;
    data['_id'] = sId;

    return data;
  }
}

class EmergencyContact {
  String? emergencyContactName;
  String? emergencyContactAddress;
  String? emergencyContactRelationship;
  String? emergencyContactNo;
  String? sId;

  EmergencyContact(
      {this.emergencyContactName,
      this.emergencyContactAddress,
      this.emergencyContactRelationship,
      this.emergencyContactNo,
      this.sId});

  EmergencyContact.fromJson(Map<String, dynamic> json) {
    emergencyContactName = json['emergencyContactName'];
    emergencyContactAddress = json['emergencyContactAddress'];
    emergencyContactRelationship = json['emergencyContactRelationship'];
    emergencyContactNo = json['emergencyContactNo'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emergencyContactName'] = emergencyContactName;
    data['emergencyContactAddress'] = emergencyContactAddress;
    data['emergencyContactRelationship'] = emergencyContactRelationship;
    data['emergencyContactNo'] = emergencyContactNo;
    data['_id'] = sId;
    return data;
  }
}

class Secretkey {
  String? cONSUMERKEY;
  String? cONSUMERSECRET;
  String? aCCESSTOKEN;
  String? tOKENSECRET;
  String? rEALM;

  Secretkey(
      {this.cONSUMERKEY,
      this.cONSUMERSECRET,
      this.aCCESSTOKEN,
      this.tOKENSECRET,
      this.rEALM});

  Secretkey.fromJson(Map<String, dynamic> json) {
    cONSUMERKEY = json['CONSUMER_KEY'];
    cONSUMERSECRET = json['CONSUMER_SECRET'];
    aCCESSTOKEN = json['ACCESS_TOKEN'];
    tOKENSECRET = json['TOKEN_SECRET'];
    rEALM = json['REALM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CONSUMER_KEY'] = cONSUMERKEY;
    data['CONSUMER_SECRET'] = cONSUMERSECRET;
    data['ACCESS_TOKEN'] = aCCESSTOKEN;
    data['TOKEN_SECRET'] = tOKENSECRET;
    data['REALM'] = rEALM;
    return data;
  }
}
