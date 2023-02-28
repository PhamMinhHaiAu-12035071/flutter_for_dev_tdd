enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credentials are invalid.';
      case DomainError.unexpected:
        return 'Unexpected error. Try again later.';
      default:
        return 'Unexpected error. Try again later.';
    }
  }
}
