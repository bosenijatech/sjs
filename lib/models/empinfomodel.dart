class EmpInfoModel {
  bool? status;
  Message? message;

  EmpInfoModel({this.status, this.message});

  EmpInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
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
  String? department;
  String? weekoffcreteria;
  String? mobileemail;
  String? mobileusername;
  String? mobilepassword;
  bool? mobileaccess;
  String? source;
  int? syncStatus;
  String? firebaseTokenid;
  String? employeeCategory;
  String? band;
  String? subBand;
  String? maritalStatus;
  String? religion;
  String? employmentStatus;
  String? hireDate;
  String? bankName;
  String? bankRoutingNo;
  String? bankAccountNo;
  String? staffType;
  String? weeklyOff;
  String? jobStatus;
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
  String? workRegion;
  String? mobileNo;

  Message(
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
      this.department,
      this.weekoffcreteria,
      this.mobileemail,
      this.mobileusername,
      this.mobilepassword,
      this.mobileaccess,
      this.source,
      this.syncStatus,
      this.firebaseTokenid,
      this.employeeCategory,
      this.band,
      this.subBand,
      this.maritalStatus,
      this.religion,
      this.employmentStatus,
      this.hireDate,
      this.bankName,
      this.bankRoutingNo,
      this.bankAccountNo,
      this.staffType,
      this.weeklyOff,
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
      this.workRegion,
      this.mobileNo,
      this.jobStatus});

  Message.fromJson(Map<String, dynamic> json) {
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
    department = json['department'];
    weekoffcreteria = json['weekoffcreteria'];
    mobileemail = json['mobileemail'];
    mobileusername = json['mobileusername'];
    mobilepassword = json['mobilepassword'];
    mobileaccess = json['mobileaccess'];
    source = json['source'];
    syncStatus = json['syncStatus'];
    firebaseTokenid = json['firebaseTokenid'];
    employeeCategory = json['employeeCategory'];
    band = json['band'];
    subBand = json['subBand'];
    maritalStatus = json['maritalStatus'];
    religion = json['religion'];
    employmentStatus = json['employmentStatus'];
    hireDate = json['hireDate'];
    bankName = json['bankName'];
    bankRoutingNo = json['bankRoutingNo'];
    bankAccountNo = json['bankAccountNo'];
    staffType = json['staffType'];
    weeklyOff = json['weeklyOff'];
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
    workRegion = json['workRegion'];
    mobileNo = json['mobileNo'];
    jobStatus = json['jobStatus'];
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
    data['department'] = department;
    data['weekoffcreteria'] = weekoffcreteria;
    data['mobileemail'] = mobileemail;
    data['mobileusername'] = mobileusername;
    data['mobilepassword'] = mobilepassword;
    data['mobileaccess'] = mobileaccess;
    data['source'] = source;
    data['syncStatus'] = syncStatus;
    data['firebaseTokenid'] = firebaseTokenid;
    data['employeeCategory'] = employeeCategory;
    data['band'] = band;
    data['subBand'] = subBand;
    data['maritalStatus'] = maritalStatus;
    data['religion'] = religion;
    data['employmentStatus'] = employmentStatus;
    data['hireDate'] = hireDate;
    data['bankName'] = bankName;
    data['bankRoutingNo'] = bankRoutingNo;
    data['bankAccountNo'] = bankAccountNo;
    data['staffType'] = staffType;
    data['weeklyOff'] = weeklyOff;
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
    data['workRegion'] = workRegion;
    data['mobileNo'] = mobileNo;
    data['jobStatus'] = jobStatus;
    return data;
  }
}

class Contacts {
  String? internalid;
  String? address;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? zipCode;
  String? phone;
  String? firstName;
  bool? defaultBilling;
  String? sId;

  Contacts({
    this.internalid,
    this.address,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.phone,
    this.firstName,
    this.defaultBilling,
    this.sId,
  });

  Contacts.fromJson(Map<String, dynamic> json) {
    internalid = json['internalid'];
    address = json['address'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipCode = json['zipCode'];
    phone = json['phone'];
    firstName = json['firstName'];
    defaultBilling = json['defaultBilling'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalid'] = internalid;
    data['address'] = address;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['zipCode'] = zipCode;
    data['phone'] = phone;
    data['firstName'] = firstName;
    data['defaultBilling'] = defaultBilling;
    data['_id'] = sId;
    return data;
  }
}

class Documents {
  String? internalid;
  String? idNo;
  String? documentNo;
  String? documentType;
  String? companyid;
  String? companyName;
  String? issueDate;
  String? expiryDate;
  String? countryofIssue;
  String? designation;
  String? remarks;
  String? remainder;
  String? remainderDate;
  String? attachment;
  String? attachmentID;
  String? sId;

  Documents(
      {this.internalid,
      this.idNo,
      this.documentNo,
      this.documentType,
      this.companyid,
      this.companyName,
      this.issueDate,
      this.expiryDate,
      this.countryofIssue,
      this.designation,
      this.remarks,
      this.remainder,
      this.remainderDate,
      this.attachment,
      this.attachmentID,
      this.sId});

  Documents.fromJson(Map<String, dynamic> json) {
    internalid = json['internalid'];
    idNo = json['idNo'];
    documentNo = json['documentNo'];
    documentType = json['documentType'];
    companyName = json['companyName'];
    companyid = json['companyID'];
    issueDate = json['issueDate'];
    expiryDate = json['expiryDate'];
    countryofIssue = json['countryOfIssue'];
    designation = json['designation'];
    remarks = json['remarks'];
    remainder = json['remainder'];
    remainderDate = json['remainderDate'];
    attachment = json['attachmentUrl'];
    attachmentID = json['attachmentID'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalid'] = internalid;
    data['idNo'] = idNo;
    data['documentNo'] = documentNo;
    data['documentType'] = documentType;
    data['companyName'] = companyName;
    data['companyID'] = companyid;
    data['issueDate'] = issueDate;
    data['expiryDate'] = expiryDate;
    data['countryOfIssue'] = countryofIssue;
    data['designation'] = designation;
    data['remarks'] = remarks;
    data['remainder'] = remainder;
    data['remainderDate'] = remainderDate;
    data['attachmentUrl'] = attachment;
    data['attachmentID'] = attachmentID;
    data['_id'] = sId;
    return data;
  }
}

class Skill {
  String? internalid;
  String? skillexperience;
  String? skillCode;
  String? skillName;
  String? skillCertificate;
  String? skillCertificateID;
  String? sId;

  Skill(
      {this.internalid,
      this.skillexperience,
      this.skillCode,
      this.skillName,
      this.skillCertificate,
      this.skillCertificateID,
      this.sId});

  Skill.fromJson(Map<String, dynamic> json) {
    internalid = json['internalid'];
    skillexperience = json['yearsOfExperience'];
    skillCode = json['skillCode'];
    skillName = json['skillName'];
    skillCertificate = json['attachmentUrl'];
    skillCertificateID = json['attachmentID'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalid'] = internalid;
    data['yearsOfExperience'] = skillexperience;
    data['skillCode'] = skillCode;
    data['skillName'] = skillName;
    data['attachmentUrl'] = skillCertificate;
    data['attachmentID'] = skillCertificateID;
    data['_id'] = sId;
    return data;
  }
}

class Qualification {
  String? internalid;
  String? qualificationId;
  String? education;
  String? college;
  String? passingYear;
  String? percentage;
  String? certificate;
  String? certificateID;
  String? sId;
  String? levelofeducation;

  Qualification(
      {this.internalid,
      this.qualificationId,
      this.education,
      this.college,
      this.passingYear,
      this.percentage,
      this.certificate,
      this.certificateID,
      this.sId,
      this.levelofeducation});

  Qualification.fromJson(Map<String, dynamic> json) {
    internalid = json['internalid'];
    qualificationId = json['qualificationId'];
    education = json['education'];
    college = json['college'];
    passingYear = json['passingYear'];
    percentage = json['percentage'];
    certificate = json['attachmentUrl'];
    certificateID = json['attachmentID'];
    sId = json['_id'];
    levelofeducation = json['levelofeducation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalid'] = internalid;
    data['qualificationId'] = qualificationId;
    data['education'] = education;
    data['college'] = college;
    data['passingYear'] = passingYear;
    data['percentage'] = percentage;
    data['attachmentUrl'] = certificate;
    data['attachmentID'] = certificateID;
    data['_id'] = sId;
    data['levelofeducation'] = levelofeducation;
    return data;
  }
}

class DependantDetails {
  String? internalid;
  String? dependantName;
  String? dob;
  String? phoneNo;
  String? relationshipId;
  String? relationship;
  bool? insurance;
  bool? airTicket;
  String? address;
  bool? educationAllowance;
  String? sId;

  DependantDetails(
      {this.internalid,
      this.dependantName,
      this.dob,
      this.phoneNo,
      this.relationshipId,
      this.relationship,
      this.insurance,
      this.airTicket,
      this.address,
      this.educationAllowance,
      this.sId});

  DependantDetails.fromJson(Map<String, dynamic> json) {
    internalid = json['internalid'];
    dependantName = json['dependantName'];
    dob = json['dob'];
    phoneNo = json['phoneNo'];
    relationship = json['relationship'];
    relationshipId = json['relationshipId'];
    insurance = json['insurance'];
    airTicket = json['airTicket'];
    address = json['address'];
    educationAllowance = json['educationAllowance'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalid'] = internalid;
    data['dependantName'] = dependantName;
    data['dob'] = dob;
    data['phoneNo'] = phoneNo;
    data['relationshipId'] = relationshipId;
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
  String? internalid;
  String? idTypeNo;
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
  String? attachmentID;
  String? sId;

  DependantIdDetails(
      {this.internalid,
      this.idTypeNo,
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
      this.attachmentID,
      this.sId});

  DependantIdDetails.fromJson(Map<String, dynamic> json) {
    internalid = json['internalid'];
    idTypeNo = json['idTypeNo'];
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
    attachment = json['attachmentUrl'];
    attachmentID = json['attachmentID'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalid'] = internalid;
    data['idTypeNo'] = idTypeNo;
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
    data['attachmentUrl'] = attachment;
    data['attachmentID'] = attachmentID;
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
