class AuthException implements Exception {
  static const Map<String, String> erros = {
    'EMAIL_EXISTS': 'E-mail já cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente, tente mais tarde',
    'EMAIL_NOT_FOUND': 'E-mail não cadastrado',
    'INVALID_PASSWORD': 'Senha inválida',
    'USER_DISABLED': 'Usuário desabilitado',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return erros[key] ?? 'Ocorreu um erro inesperado na autenticação';
  }
}
