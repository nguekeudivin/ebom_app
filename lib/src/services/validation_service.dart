class ValidationService {
  // Regular expression for Cameroonian phone number
  static final RegExp _phoneRegExp = RegExp(r'^\+237[0-9]{9}$');

  // Method to validate phone number
  bool validatePhoneNumber(String phoneNumber) {
    if (isRequired(phoneNumber)) {
      return _phoneRegExp.hasMatch(phoneNumber);
    }
    return false; // Return false if the field is empty
  }

  // Method to check if a field is required
  bool isRequired(String value) {
    return value.isNotEmpty;
  }

  // Method to validate email address
  bool validateEmail(String email) {
    // Simple regex for email validation
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return isRequired(email) && emailRegExp.hasMatch(email);
  }
}
