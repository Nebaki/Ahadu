class Jobs {
  String? id;
  String? jobTitle;
  String? workType;
  String? location;
  String? postedDateAndTime;
  String? connCode;
  String? jobDescription;
  String? catagory;
  String? level;
  String? jobDeadline;
  String? salary;
  String? status;
  String? companyName;
  String? companyLogo;

  Jobs(
      {this.id,
      this.jobTitle,
      this.workType,
      this.location,
      this.postedDateAndTime,
      this.connCode,
      this.jobDescription,
      this.catagory,
      this.level,
      this.jobDeadline,
      this.salary,
      this.status,
      this.companyName,
      this.companyLogo});

  Jobs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobTitle = json['Job_Title'];
    workType = json['Work_Type'];
    location = json['Location'];
    postedDateAndTime = json['Posted_date_and_time'];
    connCode = json['ConnCode'];
    jobDescription = json['Job_Description'];
    catagory = json['Catagory'];
    level = json['level'];
    jobDeadline = json['Job_Deadline'];
    salary = json['Salary'];
    status = json['Status'];
    companyName = json['Company_Name'];
    companyLogo = json['Company_Logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Job_Title'] = this.jobTitle;
    data['Work_Type'] = this.workType;
    data['Location'] = this.location;
    data['Posted_date_and_time'] = this.postedDateAndTime;
    data['ConnCode'] = this.connCode;
    data['Job_Description'] = this.jobDescription;
    data['Catagory'] = this.catagory;
    data['level'] = this.level;
    data['Job_Deadline'] = this.jobDeadline;
    data['Salary'] = this.salary;
    data['Status'] = this.status;
    data['Company_Name'] = this.companyName;
    data['Company_Logo'] = this.companyLogo;
    return data;
  }
}
