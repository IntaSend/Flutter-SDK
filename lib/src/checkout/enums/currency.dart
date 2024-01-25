// Enumeration representing different currencies
enum Currency { kes, usd, eur, gbp }

// Function to convert a string to a Currency enum value
Currency enumCurrency({required String string}) =>
    // Using the firstWhere method to find the first enum value that matches the condition
    Currency.values.firstWhere(
      (e) =>
          // Comparing the lowercase string representation of the enum value
          e.toString().split('.').last == string.toLowerCase(),
    );

// Function to convert a Currency enum value to its string representation
String enumStringCurrency({required Currency currency}) =>
    // Converting the enum value to its string representation
    currency
        .toString()
        // Extracting the substring after the last dot to get the enum name
        .substring(currency.toString().indexOf('.') + 1)
        // Converting the enum name to uppercase
        .toUpperCase();
