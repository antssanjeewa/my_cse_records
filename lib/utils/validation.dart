class FormValidator {
  String? validateIsEmpty(value) {
    if (value!.isEmpty) {
      return "Please Enter this Field";
    }
    return null;
  }
}
