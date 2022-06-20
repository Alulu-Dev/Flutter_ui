import 'package:receipt_management/validators.dart';
import 'package:test/test.dart';

void main() {
  test("Empty login email returns error string", () {
    var result = emailValidator("");

    expect(result, 'Email can\'t be Empty!');
  });

  test("Invalid login email address returns error message", () {
    var result = emailValidator("random.text.com");

    expect(result, 'Invalid Email Address!');
  });

  test("Empty login password returns error string", () {
    var result = passwordValidator("");

    expect(result, 'Password can\'t be Empty!');
  });
}
