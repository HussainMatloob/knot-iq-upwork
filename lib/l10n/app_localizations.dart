import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it')
  ];

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'LogOut'**
  String get logout;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout from your account?'**
  String get logoutMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @onboardingFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Redefining Wedding Planning'**
  String get onboardingFirstTitle;

  /// No description provided for @onboardingFirstSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Experience the power of intelligent simplicity with Wedplan 360°, Smartly Ever After'**
  String get onboardingFirstSubtitle;

  /// No description provided for @onboardingSecondTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan with Confidence, Live the Magic'**
  String get onboardingSecondTitle;

  /// No description provided for @onboardingSecondSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every vendor, budget, and moment, seamlessly connected under one Elegant Platform'**
  String get onboardingSecondSubtitle;

  /// No description provided for @onboardingThirdTitle.
  ///
  /// In en, this message translates to:
  /// **'Beyond Planning a 360° Experience'**
  String get onboardingThirdTitle;

  /// No description provided for @onboardingThirdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Because your wedding deserves more than organization; it deserves Perfection'**
  String get onboardingThirdSubtitle;

  /// No description provided for @onBoardingSplitFirst.
  ///
  /// In en, this message translates to:
  /// **'Wedplan 360°'**
  String get onBoardingSplitFirst;

  /// No description provided for @onBoardingSplitSecond.
  ///
  /// In en, this message translates to:
  /// **'Elegant Platform'**
  String get onBoardingSplitSecond;

  /// No description provided for @onBoardingSplitThird.
  ///
  /// In en, this message translates to:
  /// **'Perfection'**
  String get onBoardingSplitThird;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @titleApp.
  ///
  /// In en, this message translates to:
  /// **'WedPlan 360°'**
  String get titleApp;

  /// No description provided for @welcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back 💍'**
  String get welcomeText;

  /// No description provided for @letsStartText.
  ///
  /// In en, this message translates to:
  /// **'Let’s start planning your wedding.'**
  String get letsStartText;

  /// No description provided for @emailHintText.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHintText;

  /// No description provided for @passwordHintText.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHintText;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @forgot.
  ///
  /// In en, this message translates to:
  /// **'Forgotten Password?'**
  String get forgot;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orText;

  /// No description provided for @hereText.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get hereText;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @emailValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailValidate;

  /// No description provided for @validEmailValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email'**
  String get validEmailValidate;

  /// No description provided for @passwordValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordValidate;

  /// No description provided for @strongPasswordValidate.
  ///
  /// In en, this message translates to:
  /// **'Password must contain 8 characters, including uppercase, lowercase, a number, and a special character'**
  String get strongPasswordValidate;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have logged in successfully!'**
  String get loginSuccess;

  /// No description provided for @fullNameHintText.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameHintText;

  /// No description provided for @confirmPasswordHintText.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHintText;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signUp;

  /// No description provided for @alreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyAccount;

  /// No description provided for @loginText.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginText;

  /// No description provided for @nameValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameValidate;

  /// No description provided for @newPasswordValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter new password'**
  String get newPasswordValidate;

  /// No description provided for @signUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'SignUp successful!'**
  String get signUpSuccess;

  /// No description provided for @getLetsStartText.
  ///
  /// In en, this message translates to:
  /// **'🎉 Let’s get started!'**
  String get getLetsStartText;

  /// No description provided for @partnerNameHintText.
  ///
  /// In en, this message translates to:
  /// **'Partner’s Name'**
  String get partnerNameHintText;

  /// No description provided for @wedDateHintText.
  ///
  /// In en, this message translates to:
  /// **'Wedding date'**
  String get wedDateHintText;

  /// No description provided for @locationHintext.
  ///
  /// In en, this message translates to:
  /// **'Location / City'**
  String get locationHintext;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @partnerValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter partner name'**
  String get partnerValidate;

  /// No description provided for @wedDateValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter wedding date'**
  String get wedDateValidate;

  /// No description provided for @locationValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter location'**
  String get locationValidate;

  /// No description provided for @authSuccess.
  ///
  /// In en, this message translates to:
  /// **'Authentication successful!'**
  String get authSuccess;

  /// No description provided for @forgotHedText.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotHedText;

  /// No description provided for @resetInstructionDetail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive reset instructions.'**
  String get resetInstructionDetail;

  /// No description provided for @sendOtptext.
  ///
  /// In en, this message translates to:
  /// **'Send Otp'**
  String get sendOtptext;

  /// No description provided for @backLoginText.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backLoginText;

  /// No description provided for @otpResentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP has been resent to your email successfully'**
  String get otpResentSuccess;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP has been sent to your email successfully'**
  String get otpSentSuccess;

  /// No description provided for @verifyEmailText.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyEmailText;

  /// No description provided for @enterCodeText.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent to'**
  String get enterCodeText;

  /// No description provided for @verifyText.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyText;

  /// No description provided for @resendText.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendText;

  /// No description provided for @validatePinCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter your pin code'**
  String get validatePinCode;

  /// No description provided for @otpverifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully'**
  String get otpverifiedSuccess;

  /// No description provided for @resetPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordText;

  /// No description provided for @createPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Create a new password for your account.'**
  String get createPasswordText;

  /// No description provided for @resetText.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetText;

  /// No description provided for @newPasswordHintText.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordHintText;

  /// No description provided for @passwordMatchValidate.
  ///
  /// In en, this message translates to:
  /// **'Password and Confirm Password must match.'**
  String get passwordMatchValidate;

  /// No description provided for @passwordUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdateSuccess;

  /// No description provided for @wedDate.
  ///
  /// In en, this message translates to:
  /// **'Wedding Date'**
  String get wedDate;

  /// No description provided for @guestList.
  ///
  /// In en, this message translates to:
  /// **'Guest list'**
  String get guestList;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @languagesAndRegion.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get languagesAndRegion;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotification.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotification;

  /// No description provided for @taskReminder.
  ///
  /// In en, this message translates to:
  /// **'Task Reminder'**
  String get taskReminder;

  /// No description provided for @paymentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Payment Alerts'**
  String get paymentAlerts;

  /// No description provided for @supportAndLegal.
  ///
  /// In en, this message translates to:
  /// **'Support & Legal'**
  String get supportAndLegal;

  /// No description provided for @termAndcondition.
  ///
  /// In en, this message translates to:
  /// **'Term and conditions'**
  String get termAndcondition;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @vendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get vendors;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @addBudget.
  ///
  /// In en, this message translates to:
  /// **'Add Budget'**
  String get addBudget;

  /// No description provided for @addVendors.
  ///
  /// In en, this message translates to:
  /// **'Add Vendors'**
  String get addVendors;

  /// No description provided for @addGuest.
  ///
  /// In en, this message translates to:
  /// **'Add Guest'**
  String get addGuest;

  /// No description provided for @quickOverview.
  ///
  /// In en, this message translates to:
  /// **'Quick Overview'**
  String get quickOverview;

  /// No description provided for @budgetUsed.
  ///
  /// In en, this message translates to:
  /// **'Budget Used'**
  String get budgetUsed;

  /// No description provided for @tasksDone.
  ///
  /// In en, this message translates to:
  /// **'Tasks Done'**
  String get tasksDone;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @attending.
  ///
  /// In en, this message translates to:
  /// **'Attending'**
  String get attending;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @searchText.
  ///
  /// In en, this message translates to:
  /// **'Search guest by name'**
  String get searchText;

  /// No description provided for @noMatchingGuest.
  ///
  /// In en, this message translates to:
  /// **'No matching guests found'**
  String get noMatchingGuest;

  /// No description provided for @noAddedGuest.
  ///
  /// In en, this message translates to:
  /// **'No guests added yet'**
  String get noAddedGuest;

  /// No description provided for @guestEmptySreenMessage.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first guest to build your guest list and track attendance easily.'**
  String get guestEmptySreenMessage;

  /// No description provided for @cancelText.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelText;

  /// No description provided for @saveText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveText;

  /// No description provided for @updateText.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateText;

  /// No description provided for @updateGuest.
  ///
  /// In en, this message translates to:
  /// **'Update Guest'**
  String get updateGuest;

  /// No description provided for @deleteText.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteText;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @emailText.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailText;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @plusOnes.
  ///
  /// In en, this message translates to:
  /// **'Plus ones'**
  String get plusOnes;

  /// No description provided for @rsvpStatus.
  ///
  /// In en, this message translates to:
  /// **'RSVP Status'**
  String get rsvpStatus;

  /// No description provided for @firstnameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get firstnameHint;

  /// No description provided for @lastnameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get lastnameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get emailHint;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Enter note'**
  String get noteHint;

  /// No description provided for @firstNameValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get firstNameValidate;

  /// No description provided for @lastNameValidate.
  ///
  /// In en, this message translates to:
  /// **'please enter your last name'**
  String get lastNameValidate;

  /// No description provided for @noteValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter a note'**
  String get noteValidate;

  /// No description provided for @guestAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Guest added successfully'**
  String get guestAddSuccess;

  /// No description provided for @guestUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Guest updated successfully'**
  String get guestUpdateSuccess;

  /// No description provided for @guestDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Guest deleted successfully'**
  String get guestDeleteSuccess;

  /// No description provided for @sureDeleteText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record?'**
  String get sureDeleteText;

  /// No description provided for @allText.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allText;

  /// No description provided for @completedText.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedText;

  /// No description provided for @noAddedTask.
  ///
  /// In en, this message translates to:
  /// **'No tasks added yet'**
  String get noAddedTask;

  /// No description provided for @taskEmptySreenMessage.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first task to build your task list and track attendance easily.'**
  String get taskEmptySreenMessage;

  /// No description provided for @taskPendingEmptySreenMessage.
  ///
  /// In en, this message translates to:
  /// **'Start by adding pending tasks to stay organized and track progress easily.'**
  String get taskPendingEmptySreenMessage;

  /// No description provided for @taskCompletedEmptySreenMessage.
  ///
  /// In en, this message translates to:
  /// **'Start by adding completed tasks to keep a record of your accomplishments.'**
  String get taskCompletedEmptySreenMessage;

  /// No description provided for @noPendingTaskYet.
  ///
  /// In en, this message translates to:
  /// **'No pending tasks yet'**
  String get noPendingTaskYet;

  /// No description provided for @noCompletedTaskYet.
  ///
  /// In en, this message translates to:
  /// **'No completed tasks yet'**
  String get noCompletedTaskYet;

  /// No description provided for @updateTask.
  ///
  /// In en, this message translates to:
  /// **'Update Task'**
  String get updateTask;

  /// No description provided for @taskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get taskTitle;

  /// No description provided for @taskTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Going for shopping'**
  String get taskTitleHint;

  /// No description provided for @taskDesHint.
  ///
  /// In en, this message translates to:
  /// **'Buying some product for new guests'**
  String get taskDesHint;

  /// No description provided for @taskDescription.
  ///
  /// In en, this message translates to:
  /// **'Task description'**
  String get taskDescription;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @taskRemindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get taskRemindMe;

  /// No description provided for @assignTask.
  ///
  /// In en, this message translates to:
  /// **'Assign Task'**
  String get assignTask;

  /// No description provided for @assignText.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assignText;

  /// No description provided for @startDateValidate.
  ///
  /// In en, this message translates to:
  /// **'Please select a start date'**
  String get startDateValidate;

  /// No description provided for @endDateValidate.
  ///
  /// In en, this message translates to:
  /// **'Please select a end date'**
  String get endDateValidate;

  /// No description provided for @guestValidate.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one guest for task'**
  String get guestValidate;

  /// No description provided for @startEndDateValidate.
  ///
  /// In en, this message translates to:
  /// **'Start date cannot be greater than end date'**
  String get startEndDateValidate;

  /// No description provided for @taskTitleValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter your task title'**
  String get taskTitleValidate;

  /// No description provided for @taskDescriptionValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter your task description'**
  String get taskDescriptionValidate;

  /// No description provided for @taskAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task added successfully'**
  String get taskAddSuccess;

  /// No description provided for @taskUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task updated successfully'**
  String get taskUpdateSuccess;

  /// No description provided for @taskDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task deleted successfully'**
  String get taskDeleteSuccess;

  /// No description provided for @plannedText.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get plannedText;

  /// No description provided for @spentText.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spentText;

  /// No description provided for @remainingText.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remainingText;

  /// No description provided for @overAllBudgetUsage.
  ///
  /// In en, this message translates to:
  /// **'Overall Budget Usage'**
  String get overAllBudgetUsage;

  /// No description provided for @spentLowerText.
  ///
  /// In en, this message translates to:
  /// **'spent of'**
  String get spentLowerText;

  /// No description provided for @plannedLowerText.
  ///
  /// In en, this message translates to:
  /// **'planned'**
  String get plannedLowerText;

  /// No description provided for @categoryBreakDown.
  ///
  /// In en, this message translates to:
  /// **'Category breakdown'**
  String get categoryBreakDown;

  /// No description provided for @useText.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get useText;

  /// No description provided for @leftText.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get leftText;

  /// No description provided for @updateExpense.
  ///
  /// In en, this message translates to:
  /// **'Update Expense'**
  String get updateExpense;

  /// No description provided for @newExpense.
  ///
  /// In en, this message translates to:
  /// **'New Expense'**
  String get newExpense;

  /// No description provided for @amountText.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountText;

  /// No description provided for @addInstallmentText.
  ///
  /// In en, this message translates to:
  /// **'Add Installment'**
  String get addInstallmentText;

  /// No description provided for @expenseTitleText.
  ///
  /// In en, this message translates to:
  /// **'Expense title'**
  String get expenseTitleText;

  /// No description provided for @categoryText.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryText;

  /// No description provided for @writeNoteText.
  ///
  /// In en, this message translates to:
  /// **'Write note'**
  String get writeNoteText;

  /// No description provided for @expenseHint.
  ///
  /// In en, this message translates to:
  /// **'Going for shopping'**
  String get expenseHint;

  /// No description provided for @categoryHint.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get categoryHint;

  /// No description provided for @amountValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter amount'**
  String get amountValidate;

  /// No description provided for @expenseTitleValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter expense title'**
  String get expenseTitleValidate;

  /// No description provided for @paymentDate.
  ///
  /// In en, this message translates to:
  /// **'Payment date'**
  String get paymentDate;

  /// No description provided for @addPaymentText.
  ///
  /// In en, this message translates to:
  /// **'Added Payment'**
  String get addPaymentText;

  /// No description provided for @deletePaymentText.
  ///
  /// In en, this message translates to:
  /// **'Delete Payment'**
  String get deletePaymentText;

  /// No description provided for @addInstallment.
  ///
  /// In en, this message translates to:
  /// **'Add Installment'**
  String get addInstallment;

  /// No description provided for @updateInstallment.
  ///
  /// In en, this message translates to:
  /// **'Update Installment'**
  String get updateInstallment;

  /// No description provided for @categoryValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get categoryValidation;

  /// No description provided for @paymentDateValidate.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment date'**
  String get paymentDateValidate;

  /// No description provided for @installmentAmountValidate.
  ///
  /// In en, this message translates to:
  /// **'The installment amount must be less then or equal to expense amount'**
  String get installmentAmountValidate;

  /// No description provided for @dateText.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateText;

  /// No description provided for @paidText.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidText;

  /// No description provided for @unPaidText.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unPaidText;

  /// No description provided for @addBudgetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Budget added successfully'**
  String get addBudgetSuccess;

  /// No description provided for @updateBudgetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Budget updated successfully'**
  String get updateBudgetSuccess;

  /// No description provided for @budgetDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Budget deleted successfully'**
  String get budgetDeletedSuccess;

  /// No description provided for @noAddedBudget.
  ///
  /// In en, this message translates to:
  /// **'No budgets added yet'**
  String get noAddedBudget;

  /// No description provided for @budgetEmptyScreenMessage.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first budget category to plan and track your spending.'**
  String get budgetEmptyScreenMessage;

  /// No description provided for @noAddedCategory.
  ///
  /// In en, this message translates to:
  /// **'No categories added yet'**
  String get noAddedCategory;

  /// No description provided for @categoryEmptyScreen.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first category to organize your budget and track expenses more efficiently'**
  String get categoryEmptyScreen;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @updateCategory.
  ///
  /// In en, this message translates to:
  /// **'Update Category'**
  String get updateCategory;

  /// No description provided for @categoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Category title'**
  String get categoryTitle;

  /// No description provided for @supplierText.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplierText;

  /// No description provided for @colorText.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colorText;

  /// No description provided for @categoryTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter category title'**
  String get categoryTitleHint;

  /// No description provided for @supplerHint.
  ///
  /// In en, this message translates to:
  /// **'Supplier name'**
  String get supplerHint;

  /// No description provided for @colorHint.
  ///
  /// In en, this message translates to:
  /// **'Pic any color'**
  String get colorHint;

  /// No description provided for @categoryTitleValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter your category title'**
  String get categoryTitleValidate;

  /// No description provided for @supplierValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter supplier name'**
  String get supplierValidate;

  /// No description provided for @iconValidate.
  ///
  /// In en, this message translates to:
  /// **'Please select an icon for category'**
  String get iconValidate;

  /// No description provided for @chooseText.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get chooseText;

  /// No description provided for @gallerytext.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallerytext;

  /// No description provided for @cameratext.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameratext;

  /// No description provided for @selectText.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectText;

  /// No description provided for @categoryAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Category added successfully'**
  String get categoryAddSuccess;

  /// No description provided for @categoryUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get categoryUpdateSuccess;

  /// No description provided for @categoryDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Category deleted successfully'**
  String get categoryDeleteSuccess;

  /// No description provided for @noAddedVendor.
  ///
  /// In en, this message translates to:
  /// **'No added'**
  String get noAddedVendor;

  /// No description provided for @vendorEmptyScreen.
  ///
  /// In en, this message translates to:
  /// **'Stay on top of your wedding plans. Tap the + button to add your first'**
  String get vendorEmptyScreen;

  /// No description provided for @nameText.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get nameText;

  /// No description provided for @totalBudgetText.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudgetText;

  /// No description provided for @contactPersonName.
  ///
  /// In en, this message translates to:
  /// **'Contact person name'**
  String get contactPersonName;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact number'**
  String get contactNumber;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get addDocument;

  /// No description provided for @docSizeText.
  ///
  /// In en, this message translates to:
  /// **'Document large than 10 MB cannot be uploaded'**
  String get docSizeText;

  /// No description provided for @attachDocText.
  ///
  /// In en, this message translates to:
  /// **'Attached Documents'**
  String get attachDocText;

  /// No description provided for @seeAllText.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAllText;

  /// No description provided for @enterNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterNameHint;

  /// No description provided for @numberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter contact number'**
  String get numberHint;

  /// No description provided for @vendorNameValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get vendorNameValidate;

  /// No description provided for @budgetValidade.
  ///
  /// In en, this message translates to:
  /// **'Please enter total budget'**
  String get budgetValidade;

  /// No description provided for @contactPersonValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter contact person name'**
  String get contactPersonValidate;

  /// No description provided for @contactValidate.
  ///
  /// In en, this message translates to:
  /// **'Please enter contact number'**
  String get contactValidate;

  /// No description provided for @addText.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addText;

  /// No description provided for @validateInstallmentAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter installment amount'**
  String get validateInstallmentAmount;

  /// No description provided for @vendorInstallmentAmountValidate.
  ///
  /// In en, this message translates to:
  /// **'The installment amount must be less then or equal to budget amount'**
  String get vendorInstallmentAmountValidate;

  /// No description provided for @addVendorSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vendor added successfully'**
  String get addVendorSuccess;

  /// No description provided for @updateVendorSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vendor updated successfully'**
  String get updateVendorSuccess;

  /// No description provided for @deleteVendorSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vendor deleted successfully'**
  String get deleteVendorSuccess;

  /// No description provided for @notificationText.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationText;

  /// No description provided for @readText.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get readText;

  /// No description provided for @unReadText.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unReadText;

  /// No description provided for @noNotification.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotification;

  /// No description provided for @notificationEmptyScreenText.
  ///
  /// In en, this message translates to:
  /// **'Stay connected to receive updates and notifications'**
  String get notificationEmptyScreenText;

  /// No description provided for @upComingReminder.
  ///
  /// In en, this message translates to:
  /// **'Upcoming reminders'**
  String get upComingReminder;

  /// No description provided for @noUpcommingReminders.
  ///
  /// In en, this message translates to:
  /// **'No upcoming reminders yet'**
  String get noUpcommingReminders;

  /// No description provided for @upcomingReminderEmptyScreenText.
  ///
  /// In en, this message translates to:
  /// **'Stay connected to receive updates and reminders'**
  String get upcomingReminderEmptyScreenText;

  /// No description provided for @selectLanguageText.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguageText;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @frenchLanguage.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get frenchLanguage;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicLanguage;

  /// No description provided for @spanishLanguage.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanishLanguage;

  /// No description provided for @italianLanguage.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italianLanguage;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @fullNameText.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameText;

  /// No description provided for @capitalNameText.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get capitalNameText;

  /// No description provided for @refreshText.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshText;

  /// No description provided for @noProfileDataText.
  ///
  /// In en, this message translates to:
  /// **'No data available yet'**
  String get noProfileDataText;

  /// No description provided for @emptyProfileScreenText.
  ///
  /// In en, this message translates to:
  /// **'Tap refresh to load the latest profile data'**
  String get emptyProfileScreenText;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile update successfully'**
  String get profileUpdateSuccess;

  /// No description provided for @hintTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter title'**
  String get hintTextTitle;

  /// No description provided for @hintTextDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get hintTextDescription;

  /// No description provided for @dateHint.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get dateHint;

  /// No description provided for @descriptionText.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionText;

  /// No description provided for @helloText.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get helloText;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get currencySymbol;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
