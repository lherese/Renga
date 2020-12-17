public enum Renga {

  static var blockPitch: Int = 16

  public static var lineCount: Int {
    blockPitch
  }

  static var sheetCount: Int {
    lineCount * lineCount
  }

  static var blockCount: Int {
    lineCount * sheetCount
  }

}
