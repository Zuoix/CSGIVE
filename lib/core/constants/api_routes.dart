class ApiRoutes {
  static const pureUrl = 'https://super.csgive.app';
  static const baseUrl = '$pureUrl/api/';

  static const login = 'users/login';
  static const register = 'users/register';
  static const forgotPassword = 'users/forgotten_password';
  static const changePassword = 'users/change_password';
  static const profilepicture = 'users/getprofilepicture';
  static const notification = 'notifications/getusernotifications';
  static const getappointmentbydate = 'appointment';
  static const submitappointment= 'appointment/set';
  static const message = 'notifications/getusermessages';


  static const livestream = 'churchcontent/livestream';

  static const church = 'church';
  static const churches = 'churches';

  static const donationTypes = 'getdonationtypes';

  static const donationHistory = 'donationhistory';

  static const paypalReturnURL = '/paypal-done';
  static const paypalCancelURL = '/paypal-cancelled';

  static const events = 'events';
  static const getupcomingevents = 'getupcomingevents';
  static const videos = 'churchcontent/recent?contentType=video&limit=10';
  static const sermons = 'churchcontent/recent?contentType=video&limit=10';

  static const initiatePaymentIntent = 'initiatePaymentIntent';
  static const setPaymentStatus = 'setPaymentStatus';
  static const paymentStatus = 'paymentStatus';

}

class MoneyMoneyApiRoutes {
  static const baseUrl = 'https://api.sandbox.pawapay.cloud';
  static const deposit = '/deposits';
  static const activeConfiguration = '/active-conf';
  static const paymentPage = '/v1/widget/sessions';
}
