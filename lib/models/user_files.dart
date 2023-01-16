class UserFiles {
  String title;
  String des;
  String fileUrl;
  UserFiles(this.title, this.des, this.fileUrl);

  UserFiles.fromMap(Map<dynamic, dynamic> data)
      : title = data['title'],
        des = data['des'],
        fileUrl = data['fileUrl'];
}
