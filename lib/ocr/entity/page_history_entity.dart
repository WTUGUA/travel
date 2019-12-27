class PageHistoryEntity {
  bool checked = false;
  int type = 0; //  type 0 是ocr   type 1 是翻译
  int id; //数据在表中的id
  var img; //保存的所有图片
  String title; //标题

  //String OCRContent
  String ocrContent;

  //String TransContent;
  String transContent;

  PageHistoryEntity(this.img, this.title, this.type, this.id, this.ocrContent,
      this.transContent);
}
