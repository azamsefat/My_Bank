import 'loan.dart';
import 'transactions.dart';


class User {
  final String name;
  final String email;
  final String password;
  final String accountNumber;
  final String accountType; // ✅ Add this line
  final bool isAdmin;
  double balance;
  List<Loan> loans;
  List<Transaction> transactions;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.accountNumber,
    required this.accountType, // ✅ Add this line
    this.isAdmin = false,
    this.balance = 0,
    List<Loan>? loans,
    List<Transaction>? transactions,
  })  : loans = loans ?? [],
        transactions = transactions ?? [];

  User.empty()
      : name = '',
        email = '',
        password = '',
        accountNumber = '',
        accountType = '', // ✅ Add this line
        isAdmin = false,
        balance = 0,
        loans = [],
        transactions = [];
}
