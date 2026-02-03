enum Category {
  subscription('Subscription'),
  groceries('Groceries'),
  transport('Transport'),
  shopping('Shopping');

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
