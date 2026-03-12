enum Category {
  subscription('サブスクリプション'),
  groceries('食料品'),
  transport('交通'),
  shopping('ショッピング');

  const Category(this.displayName);
  final String displayName;

  static Category? fromString(String value) {
    for (final category in Category.values) {
      if (category.name == value || category.displayName == value) {
        return category;
      }
    }
    return null;
  }
}
