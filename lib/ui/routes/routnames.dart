import 'package:flutter/material.dart';
import 'package:xuriti/ui/screens/bhome_screens/add_company.dart';
import 'package:xuriti/ui/screens/bhome_screens/home_companylist_screen.dart';
import 'package:xuriti/ui/screens/bhome_screens/overdue_screens/overdue_deatils.dart';
import 'package:xuriti/ui/screens/bhome_screens/paynow_screen.dart';
import 'package:xuriti/ui/screens/bhome_screens/savemore_screens/savemore_details.dart';
import 'package:xuriti/ui/screens/bhome_screens/upcoming_screens/upcoming_details.dart';
import 'package:xuriti/ui/screens/guide_screen/guide_details.dart';
import 'package:xuriti/ui/screens/invoices_screens/payment_history/interest_payment_details.dart';
import 'package:xuriti/ui/screens/invoices_screens/pending_invoices_screen/all_pending_invoices.dart';
import 'package:xuriti/ui/screens/invoices_screens/pending_invoices_screen/paidInvoice_detais.dart';
import 'package:xuriti/ui/screens/invoices_screens/pending_invoices_screen/pending_invoice_report.dart';
import 'package:xuriti/ui/screens/kyc_screens/aadhaar_card_screen.dart';
import 'package:xuriti/ui/screens/kyc_screens/address_proof.dart';
import 'package:xuriti/ui/screens/kyc_screens/banking_details.dart';
import 'package:xuriti/ui/screens/kyc_screens/bussiness_proof_screen.dart';
import 'package:xuriti/ui/screens/kyc_screens/financial_gst_details_screen.dart';
import 'package:xuriti/ui/screens/kyc_screens/firm_details_screens.dart';
import 'package:xuriti/ui/screens/kyc_screens/kyc_verification_screen.dart';
import 'package:xuriti/ui/screens/kyc_screens/ownership_proof_screen.dart';
import 'package:xuriti/ui/screens/kyc_screens/pan_details_screen.dart';
import 'package:xuriti/ui/screens/kyc_screens/kyc_submission_screen.dart';
import 'package:xuriti/ui/screens/kyc_screens/store_images.dart';
import 'package:xuriti/ui/screens/kyc_screens/vintage_proof_screen.dart';
import 'package:xuriti/ui/screens/paynow_screens/payment_failed_screen.dart';
import 'package:xuriti/ui/screens/paynow_screens/payment_success_screen.dart';
import 'package:xuriti/ui/screens/paynow_screens/total_payment.dart';
import 'package:xuriti/ui/screens/profile_screens/edit_profile_screen.dart';
import 'package:xuriti/ui/screens/profile_screens/profile_screen.dart';
import 'package:xuriti/ui/screens/registration_screens/business_register_screen.dart';
import 'package:xuriti/ui/screens/registration_screens/buisness_registered_screen.dart';
import 'package:xuriti/ui/screens/home_screen.dart';
import 'package:xuriti/ui/screens/reports_screens/reports_option_screen.dart';
import 'package:xuriti/ui/screens/reports_screens/transactional_ledger.dart';
import 'package:xuriti/ui/screens/rewards_screens/coupon_screens/apply_screen.dart';
import 'package:xuriti/ui/screens/rewards_screens/coupon_screens/applycoupon_screen.dart';
import 'package:xuriti/ui/screens/rewards_screens/reward_screen/all_rewards_screen.dart';
import 'package:xuriti/ui/screens/rewards_screens/reward_screen/claimed_reward_screen.dart';
import 'package:xuriti/ui/screens/rewards_screens/reward_screen/reward_screen.dart';
import 'package:xuriti/ui/screens/rewards_screens/reward_screen/single_reward_screen.dart';
import 'package:xuriti/ui/screens/signup_and_login_screens/login_screen.dart';
import 'package:xuriti/ui/screens/signup_and_login_screens/signUp_screen.dart';
import 'package:xuriti/ui/screens/starting_screens/company_list.dart';
import 'package:xuriti/ui/screens/starting_screens/get_started_screen.dart';
import 'package:xuriti/ui/screens/starting_screens/landing_Screen.dart';
import 'package:xuriti/ui/screens/starting_screens/onboard_screen.dart';
import 'package:xuriti/ui/screens/starting_screens/splash_screen.dart';
import 'package:xuriti/wrapper.dart';
import '../screens/kyc_screens/kycVerification_secondScreen.dart';
import '../screens/kyc_screens/mobile_verification_screen.dart';
import '../screens/guide_screen/all_guide_screen.dart';
import '../screens/invoices_screens/all_sellers_screens/sellers_details.dart';
import '../screens/invoices_screens/payment_history/all_payment_details.dart';
import '../screens/invoices_screens/pending_invoices_screen/pending_invoices_screen.dart';
import '../screens/signup_and_login_screens/foget_password2_screen.dart';
import '../screens/signup_and_login_screens/forget_password_screen.dart';
import '../screens/starting_screens/company_register_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signUp':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/onBoard':
        return MaterialPageRoute(builder: (_) => const Onboard());
      case '/businessRegister':
        return MaterialPageRoute(builder: (_) => const BusinessRegister());
      case '/businessRegistered':
        return MaterialPageRoute(builder: (_) => const BusinessRegistered());
      case '/landing':
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case '/profile_screens':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/overdueDetails':
        return MaterialPageRoute(builder: (_) => const OverdueDetails());
      case '/upcomingDetails':
        return MaterialPageRoute(builder: (_) => UpcomingDetails());
      case '/savemoreDetails':
        return MaterialPageRoute(builder: (_) => const SavemoreDetails());
      case '/paynow':
        return MaterialPageRoute(builder: (_) => const PaynowScreen());
      case '/applyCoupon':
        return MaterialPageRoute(builder: (_) => const ApplycouponScreen());
      case '/apply':
        return MaterialPageRoute(builder: (_) => const ApplyScreen());
      case '/editProfile':
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case '/allRewards':
        return MaterialPageRoute(builder: (_) => const AllRewardsScreen());
      case '/rewards':
        return MaterialPageRoute(builder: (_) => const RewardScreen());
      case '/singleReward':
        return MaterialPageRoute(builder: (_) => const SingleReward());
      case '/forgetPassword':
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case '/forgetPassword2':
        return MaterialPageRoute(
            builder: (_) => const ForgetPasswordSecondScreen());
      case '/transactionalLedger':
        return MaterialPageRoute(builder: (_) => TransactionalLedger());
      case '/allPaymentDetails':
        return MaterialPageRoute(builder: (_) => AllPaymentDetails());
      case '/interestPaymentDetails':
        return MaterialPageRoute(
            builder: (_) => const InterestPaymentDetails());
      case '/sellersDetails':
        return MaterialPageRoute(builder: (_) => const SellersDetails());
      case '/claimedReward':
        return MaterialPageRoute(builder: (_) => const ClaimedReward());
      case '/pendingInvoiceReport':
        return MaterialPageRoute(builder: (_) => const PendingInvoiceReport());
      case '/allGuideScreen':
        return MaterialPageRoute(builder: (_) => const AllGuideScreen());
      case '/guideDetails':
        return MaterialPageRoute(builder: (_) => const AllGuideDetails());
      case '/getStarted':
        return MaterialPageRoute(builder: (_) => const GetStartedScreen());
      case '/companyList':
        return MaterialPageRoute(builder: (_) => const CompanyList());
      case '/kycVerification':
        return MaterialPageRoute(builder: (_) => const KycVerification());
      case '/panDetails':
        return MaterialPageRoute(builder: (_) => const PanDetails());
      case '/oktWrapper':
        return MaterialPageRoute(builder: (_) => const OktWrapper());

      case '/ownershipProof':
        return MaterialPageRoute(builder: (_) => const OwnershipProof());
      case '/businessProof':
        return MaterialPageRoute(builder: (_) => const BussinessProof());
      case '/bankDetails':
        return MaterialPageRoute(builder: (_) => const BankingDetails());
      case '/firmDetails':
        return MaterialPageRoute(builder: (_) => const FirmDetails());
      case '/vintageProof':
        return MaterialPageRoute(builder: (_) => const VintageProof());
      case '/addressProof':
        return MaterialPageRoute(builder: (_) => const AddressProof());
      case '/aadhaarCard':
        return MaterialPageRoute(builder: (_) => AadhaarCard(AadhaarCard));
      case '/mobileVerification':
        return MaterialPageRoute(builder: (_) => const MobileVerification());
      case '/finGstDetails':
        return MaterialPageRoute(builder: (_) => const FinancialGstDetails());
      case '/kycSubmission':
        return MaterialPageRoute(builder: (_) => const kycSubmission());
      case '/kycnextstep':
        return MaterialPageRoute(
            builder: (_) => const KycVerificationNextStep());
      case '/reportsOptions':
        return MaterialPageRoute(builder: (_) => const ReportsOptionScreen());

      case '/homeCompanyList':
        return MaterialPageRoute(builder: (_) => const HomeCompanyList());
      case '/addCompany':
        return MaterialPageRoute(builder: (_) => const AddCompany());
      case '/totalPayment':
        return MaterialPageRoute(builder: (_) => const TotalPayment());
      case '/paymentSuccess':
        return MaterialPageRoute(builder: (_) => const PaymentSuccess());
      case '/paymentFailed':
        return MaterialPageRoute(builder: (_) => const PaymentFailed());
      case '/companyRegisterScreen':
        return MaterialPageRoute(builder: (_) => const CompanyRegisterScreen());
      case '/paidInvoiceDetails':
        return MaterialPageRoute(builder: (_) => const PaidInvoiceDetails());
      case '/storeImages':
        return MaterialPageRoute(builder: (_) => const StoreImages());

      // case '/allPendingInvoices':
      //   return MaterialPageRoute(
      //       builder: (_) => AllPendingInvoiceWidget(
      //             amount: '',
      //             companyName: '',
      //             dayCount: '',
      //             maxHeight: 100,
      //             maxWidth: 10,
      //             savedAmount: '',
      //           ));
      case '/pInvoices':
        return MaterialPageRoute(builder: (_) => const PInvoices());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child:
                        Text('There is no route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
