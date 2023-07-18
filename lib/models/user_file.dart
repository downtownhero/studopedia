class UserFile {
  String uid;
  String title;
  String des;
  String fileUrl;
  List<Map<String, dynamic>> list = List<Map<String, dynamic>>();

  UserFile({
    this.uid,
    this.title,
    this.des,
    this.fileUrl,
    this.list,
  });

//  List<Map> file() {
//    List<Map<String, dynamic>> fileList = [
//      {
//        'title': title,
//        'des': des,
//        'fileUrl': fileUrl,
//      }
//    ];
//    return fileList;
//  }
}
