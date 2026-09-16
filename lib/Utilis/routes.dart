// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide_application/Controllers/authentication/auth_gate.dart';
import 'package:tour_guide_application/Screens/create_album_screen.dart';
import 'package:tour_guide_application/Screens/Calendar/calendar_view.dart';
import 'package:tour_guide_application/Screens/city_selection_screen.dart';
import 'package:tour_guide_application/Screens/authentication/login_screen.dart';
import 'package:tour_guide_application/Screens/authentication/signup_screen.dart';
import 'package:tour_guide_application/Screens/interface/profile_screen.dart';
import 'package:tour_guide_application/Utilis/widgets/logo_screen.dart';
import 'package:tour_guide_application/Screens/interface/onboarding_screen.dart';
import 'package:tour_guide_application/Screens/hire_tour_guide.dart';
import 'package:tour_guide_application/Screens/locations/location_entry_screen.dart';
import 'package:tour_guide_application/Screens/map_screen.dart';
import 'package:tour_guide_application/Screens/review_screen.dart';
import 'package:tour_guide_application/Screens/view_album_screen.dart';
import 'package:tour_guide_application/Screens/map_selection_Screen.dart';
import 'package:tour_guide_application/Screens/Chat%20Bot/chatbot_screen.dart';
import 'package:tour_guide_application/Screens/authentication/reset_password_screen.dart';
import 'package:tour_guide_application/Screens/interface/edit_profile_screen.dart';
import 'package:tour_guide_application/Screens/authentication/help_center_screen.dart';
import'package:tour_guide_application/Screens/interface/home_screen.dart';
import'package:tour_guide_application/Screens/confirmation_screen.dart';
import'package:tour_guide_application/Screens/payment_screen.dart';
import 'package:tour_guide_application/Screens/billing_detail_screen.dart';
// import 'package:path/path.dart';
// import 'package:tour_guide_application/Authentication/auth_gate.dart';
// import 'package:tour_guide_application/Screens/destination_info_screen.dart';
// import'package:tour_guide_application/screens/main_screen.dart';



class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String calendar = '/calendar';
  static const String citySelection = '/city_selection';
  static const String map = '/map';
  static const String viewAlbum = '/view_album';
  static const String addPhoto = '/add_photo';
  static const String mapSelection = '/map_selection';
  static const String review = '/review';
  static const String locationEntry = '/location_entry';
  static const String hireTourGuide = '/hire_tour_guide';
  static const String confirmation = '/confirmation';
  static const String payment = '/payment';
  static const String billing = '/billing';
  static const String profile = '/profile';
  static const String authGate = '/auth';
  static const String logo = '/logo';
  static const String onboarding = '/onboarding';
  static const String chatbot = '/chatbot';
  static const String resetPassword = '/reset_password';
  static const String editProfile = '/edit_profile';
  static const String helpCenter = '/help_center';
  static const String destinationInfo = '/destination_info';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      calendar: (context) => const CalendarView(),
      editProfile: (context) => const EditProfileScreen(),
      helpCenter: (context) => const HelpCenterScreen(),
      citySelection: (context) => const CitySelectionScreen(),
      // map route requires arguments, handled in generateRoute
      mapSelection: (context) => const MapSelectionScreen(),
      viewAlbum: (context) => const ViewAlbumScreen(),
      addPhoto: (context) => const CreateAlbumScreen(),
      review: (context) => const ReviewScreen(backgroundColor: Colors.transparent),
      locationEntry: (context) => LocationEntryScreen(),
      hireTourGuide: (context) => const HireTourGuideScreen(),
      payment: (context) => const PaymentScreen(
            guideName: '',
            duration: '',
            totalAmount: 0.0,
            bookingId: '',
          ),
      billing: (context) => const BillingDetailsScreen(
            guideName: '',
            price: 0,
            imageUrl: '',
          ),
      profile: (context) => const ProfileScreen(),
      authGate: (context) => const AuthGate(),
      logo: (context) => const LogoScreen(),
      onboarding: (context) => OnboardingScreen(nextScreen: const AuthGate()),
      chatbot: (context) => const ChatbotScreen(),
      resetPassword: (context) => const ResetPasswordScreen(),
    };
  }

static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case helpCenter:
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarView());
      case citySelection:
        return MaterialPageRoute(builder: (_) => const CitySelectionScreen());
      case destinationInfo:
        final args = settings.arguments as String;
        // return MaterialPageRoute(
        //   builder: (_) => DestinationInfoScreen(placeId: args),
        // );
      case map:
        final args = settings.arguments as Map<String, dynamic>?;
        final placeName = args?['placeName'] as String? ?? 'Unknown Place';
        final destination = args?['destination'] as LatLng? ?? const LatLng(0.0, 0.0);
        return MaterialPageRoute(builder: (_) => MapScreen(placeName: placeName, destination: destination));
      case viewAlbum:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => ViewAlbumScreen(),
        );
      case addPhoto:
        return MaterialPageRoute(builder: (_) => const CreateAlbumScreen());
      case mapSelection:
        return MaterialPageRoute(builder: (_) => const MapSelectionScreen());
      case review:
        return MaterialPageRoute(builder: (_) => const ReviewScreen(backgroundColor: Colors.transparent,));
      case confirmation:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ConfirmationScreen(
            guideName: args?['guideName'] as String? ?? '',
            duration: args?['duration'] as String? ?? '',
            totalAmount: args?['totalAmount'] as double? ?? 0.0,
            bookingId: args?['bookingId'] as String? ?? '',
          ),
        );
      case payment:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(
            guideName: args?['guideName'] as String? ?? '',
            duration: args?['duration'] as String? ?? '',
            totalAmount: args?['totalAmount'] as double? ?? 0.0,
            bookingId: args?['bookingId'] as String? ?? '',
          ),
        );
      case billing:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BillingDetailsScreen(
            guideName: args?['guideName'] as String? ?? '',
            price: args?['price'] as int? ?? 0,
            imageUrl: args?['imageUrl'] as String? ?? '',
          ),
        );
      case locationEntry:
        return MaterialPageRoute(builder: (_) => LocationEntryScreen());
      case hireTourGuide:
        return MaterialPageRoute(builder: (_) => const HireTourGuideScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case logo:
        return MaterialPageRoute(builder: (_) => const LogoScreen());
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(nextScreen: const AuthGate()),
        );
      case login:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      case signup:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      case chatbot:
        return MaterialPageRoute(builder: (_) => const ChatbotScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
    throw Exception('Route not found: ${settings.name}');
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static void navigateToSignup(BuildContext context) {
    Navigator.pushReplacementNamed(context, signup);
  }

  static void navigateToViewAlbum(BuildContext context) {
    Navigator.pushNamed(context, viewAlbum);
  }
  static void navigateToEditProfile(BuildContext context) {
    Navigator.pushNamed(context, editProfile);
  }
  static void navigateToHelpCenter(BuildContext context) {
    Navigator.pushNamed(context, helpCenter);
  }
  static void navigateToCalendar(BuildContext context) {
    Navigator.pushNamed(context, calendar);
  }

  static void navigateToMapSelection(BuildContext context) {
    Navigator.pushNamed(context, mapSelection);
  }
  static void navigateToresetPassword(BuildContext context) {
    Navigator.pushNamed(context, resetPassword);
  }
  static void navigateToCitySelection(BuildContext context) {
    Navigator.pushNamed(context, citySelection);
  }

  static void navigateToMap(BuildContext context, {required String placeName, required LatLng destination}) {
    Navigator.pushNamed(
      context,
      map,
      arguments: {'placeName': placeName, 'destination': destination},
    );
  }

  static void navigateToAddPhoto(BuildContext context) {
    Navigator.pushNamed(context, addPhoto);
  }

  static void navigateToLocationEntry(BuildContext context, LatLng pickedLocation) {
    Navigator.pushNamed(
      context,
      locationEntry,
      arguments: pickedLocation,
    );
  }

  static void navigateToHireTourGuide(BuildContext context) {
    Navigator.pushNamed(context, hireTourGuide);
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, profile);
  }

  static void navigateToOnboarding(BuildContext context) {
    Navigator.pushReplacementNamed(context, onboarding);
  }

  static void navigateToReview(BuildContext context) {
    Navigator.pushNamed(context, review);
  }

  static void navigateToChatbot(BuildContext context) {
    Navigator.pushNamed(context, chatbot);
  }

  static void navigateToConfirmation(BuildContext context, {
    required String guideName,
    required String duration,
    required double totalAmount,
    required String bookingId,
  }) {
    Navigator.pushNamed(
      context,
      confirmation,
      arguments: {
        'guideName': guideName,
        'duration': duration,
        'totalAmount': totalAmount,
        'bookingId': bookingId,
      },
    );
  }

  static void navigateToPayment(BuildContext context, {
    required String guideName,
    required String duration,
    required double totalAmount,
    required String bookingId,
  }) {
    Navigator.pushNamed(
      context,
      payment,
      arguments: {
        'guideName': guideName,
        'duration': duration,
        'totalAmount': totalAmount,
        'bookingId': bookingId,
      },
    );
  }

  static void navigateToBilling(BuildContext context, {
    required String guideName,
    required int price,
    required String imageUrl,
  }) {
    Navigator.pushNamed(
      context,
      billing,
      arguments: {
        'guideName': guideName,
        'price': price,
        'imageUrl': imageUrl,
      },
    );
  }
}