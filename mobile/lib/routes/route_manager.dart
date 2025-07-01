class RouteManager {
  // شاشات الدخول والتسجيل
  static const String auth = '/auth';

  // لوحات التحكم
  static const String patientDashboard = '/patient-dashboard';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String pharmacistDashboard = '/pharmacist-dashboard';
  static const String doctorsList = '/doctors-list';

  // الطبيب
  static const String addPrescription = '/add-prescription';
  static const String appointment = '/appointment';

  // الإعدادات
  static const String settings = '/settings';

  // المريض
  static const String patientProfile = '/patient-profile';
  static const String patientHistory = '/patient-history';
  static const String prescriptions = '/prescriptions';
  static const String prescriptionList = '/prescription-list';

  // الصيدلي
  static const String pharmacyDashboard = '/pharmacy-dashboard';
  static const String pharmacyOrders = '/pharmacy-orders';
  static const String pharmacyProfile = '/pharmacy-profile';

  // صفحات عامة
  static const String splash = '/splash';
  static const String roleSelection = '/role-selection'; // ★ جديد
  static const String onboarding = '/onboarding';
  static const String notFound = '/not-found';
}
