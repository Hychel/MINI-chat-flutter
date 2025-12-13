abstract class AppStrings {
  // Заголовки
  static const String appTitle = 'Mini Chat';
  static const String loginTitle = 'Welcome back';
  static const String signupTitle = 'Create an account';
  static const String chatAppBar = 'Active Chats';
  static const String profileTitle = 'Profile';
  static const String newChatTitle = 'New Chat';

  // Кнопки
  static const String loginButton = 'Log in';
  static const String registerButton = 'Register';
  static const String continueButton = 'Continue';
  static const String createChatButton = 'Create chat';
  static const String signOutButton = 'Quit from account';

  // Поля вводу
  static const String emailHint = 'Gmail@gmail.com';
  static const String passwordHint = 'Password';
  static const String nicknameHint = '@username';
  static const String messageHint = 'Message...';

  // Повідомлення
  static const String noMessages = 'No messages yet';
  static const String deleteChatConfirm = 'Delete chat?';
  static const String deleteChatContent = 'Are you sure you want to delete chat with ';
  static const String termsAndPolicy = "By clicking continue, you agree to our Terms of Service and Privacy Policy";
  static const String haveAccount = 'Already have an account? Sign In';
  static const String noAccount = "Don't have an account? Register";

  // Стан
  static const String lastSeenRecently = 'Last seen recently';
  static const String onlineStatus = 'Online';
  static const String noMessagesYet = 'No messages yet';

  static const String emailErrorRequired = 'Please enter your email address';
  static const String emailErrorInvalid = 'Please enter a valid email address';
  static const String emailErrorShort = 'Email address is too short';

  static const String passwordErrorRequired = 'Please enter a password';
  static const String passwordErrorShort = 'Password must be at least 6 characters';

  static const String nicknameErrorRequired = 'Please enter a nickname';
  static const String nicknameErrorShort = 'Nickname must be at least 2 characters';
  static const String nicknameErrorLong = 'Nickname is too long (maximum 20 characters)';
  static const String nicknameErrorChars = 'Nickname can only contain letters, numbers and underscores';
  static const String nicknameErrorSpaces = 'Nickname cannot contain spaces';

  static const String messageErrorEmpty = 'Message cannot be empty';
  static const String messageErrorShort = 'Message is too short';
  static const String messageErrorLong = 'Message is too long (maximum 500 characters)';

  static const String requiredFieldError = 'This field is required';

  const AppStrings._();
}


