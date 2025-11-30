import '../data/model/body/language_model.dart';

class AppConstants {
  static const String appName = 'Smart Table';
  static const double appVersion = 1.0;

  static const String baseUrl = 'http://192.168.1.3:8000/';
  static const String LOGIN_URI = '/dashboard-mobile/login/';
  static const String WORK_DAYS = '/dashboard-mobile/load-workdays-data/';
  static const String CONTACT_US = '/dashboard-mobile/contact-us/';
  static const String WAITING_CLASS =
      '/dashboard-mobile/load-waiting-classes-page/';
  static const String TEACHER_LIST = '/dashboard-mobile/add-waiting-class';
  static const String ABSENT_TEACHER = '/dashboard-mobile/set-absent-teachers/';
  static const String UN_SET_ABSENT_TEACHER =
      '/dashboard-mobile/set-absent-teachers/';
  static const String ADD_WAITING_TEACHER =
      '/dashboard-mobile/add-waiting-class/';

  static const String GET_TEACHERS_NAMES_LIST =
      "/dashboard-mobile/load-teachers-page/";

  static const String CLASS_ROOM_PAGES =
      '/dashboard-mobile/load-classrooms-page/';

  static const String CLASSESS_META = '/dashboard-mobile/classes/';

  static const String NOTIFICATION_COUNT = '/dashboard-mobile/new-notif-count/';
  static const String NOTIFICATION = '/dashboard-mobile/notifications/';
  static const String DELETE_NOTIFICATION =
      '/dashboard-mobile/delete-notification/';

  static const String WAITING_TEACHER = '/dashboard-mobile/add-waiting-class/';

  static const SEND_NOTIFICATION = "/dashboard-mobile/send-notif-msg/";

  static const String APP_KEY = 'appKey';
  static const String USER_NAME = 'username';
  static const String about_url = "http://192.168.1.3:8000/about/";

  static const String NO_INTERNET_MESSAGE = 'NO_INTERNET_MESSAGE';
  static const String loginUri = '/api/v1/auth/login';
  static const String tokenUri = '/api/v1/customer/cm-firebase-token';
  static const String placeOrderUri = '/api/v1/customer/order/place';
  static const String addressListUri = '/api/v1/customer/address/list';
  static const String zoneUri = '/api/v1/config/get-zone-id';
  static const String removeAddressUri =
      '/api/v1/customer/address/delete?address_id=';
  static const String addAddressUri = '/api/v1/customer/address/add';
  static const String updateAddressUri = '/api/v1/customer/address/update/';
  static const String setMenuUri = '/api/v1/products/set-menu';
  static const String customerInfoUri = '/api/v1/customer/info';
  static const String couponUri = '/api/v1/coupon/list';
  static const String couponApplyUri = '/api/v1/coupon/apply?code=';
  static const String runningOrderListUri =
      '/api/v1/customer/order/running-orders';
  static const String runningSubscriptionOrderListUri =
      '/api/v1/customer/order/order-subscription-list';
  static const String historyOrderListUri = '/api/v1/customer/order/list';
  static const String orderCancelUri = '/api/v1/customer/order/cancel';
  static const String codSwitchUri = '/api/v1/customer/order/payment-method';
  static const String orderDetailsUri =
      '/api/v1/customer/order/details?order_id=';
  static const String wishListGetUri = '/api/v1/customer/wish-list';
  static const String addWishListUri = '/api/v1/customer/wish-list/add?';
  static const String removeWishListUri = '/api/v1/customer/wish-list/remove?';
  static const String notificationUri = '/api/v1/customer/notifications';
  static const String updateProfileUri = '/api/v1/customer/update-profile';
  static const String searchUri = '/api/v1/';
  static const String reviewUri = '/api/v1/products/reviews/submit';
  static const String productDetailsUri = '/api/v1/products/details/';
  static const String lastLocationUri =
      '/api/v1/delivery-man/last-location?order_id=';
  static const String deliveryManReviewUri =
      '/api/v1/delivery-man/reviews/submit';
  static const String restaurantUri = '/api/v1/restaurants/get-restaurants';
  static const String popularRestaurantUri = '/api/v1/restaurants/popular';
  static const String latestRestaurantUri = '/api/v1/restaurants/latest';
  static const String restaurantDetailsUri = '/api/v1/restaurants/details/';
  static const String basicCampaignUri = '/api/v1/campaigns/basic';
  static const String itemCampaignUri = '/api/v1/campaigns/item';
  static const String basicCampaignDetailsUri =
      '/api/v1/campaigns/basic-campaign-details?basic_campaign_id=';
  static const String interestUri = '/api/v1/customer/update-interest';
  static const String suggestedFoodUri = '/api/v1/customer/suggested-foods';
  static const String restaurantReviewUri = '/api/v1/restaurants/reviews';
  static const String distanceMatrixUri = '/api/v1/config/distance-api';
  static const String searchLocationUri =
      '/api/v1/config/place-api-autocomplete';
  static const String placeDetailsUri = '/api/v1/config/place-api-details';
  static const String geocodeUri = '/api/v1/config/geocode-api';
  static const String socialLoginUri = '/api/v1/auth/social-login';
  static const String socialRegisterUri = '/api/v1/auth/social-register';
  static const String updateZoneUri = '/api/v1/customer/update-zone';
  static const String walletTransactionUri =
      '/api/v1/customer/wallet/transactions';
  static const String loyaltyTransactionUri =
      '/api/v1/customer/loyalty-point/transactions';
  static const String loyaltyPointTransferUri =
      '/api/v1/customer/loyalty-point/point-transfer';
  static const String customerRemoveUri = '/api/v1/customer/remove-account';
  static const String conversationListUri = '/api/v1/customer/message/list';
  static const String searchConversationListUri =
      '/api/v1/customer/message/search-list';
  static const String messageListUri = '/api/v1/customer/message/details';
  static const String sendMessageUri = '/api/v1/customer/message/send';
  static const String zoneListUri = '/api/v1/zone/list';
  static const String restaurantRegisterUri = '/api/v1/auth/vendor/register';
  static const String dmRegisterUri = '/api/v1/auth/delivery-man/store';
  static const String restaurantPackagesUri =
      '/api/v1/auth/vendor/package-view';
  static const String businessPlanUri = '/api/v1/auth/vendor/business_plan';
  static const String refundReasonsUri =
      '/api/v1/customer/order/refund-reasons';
  static const String refundRequestUri =
      '/api/v1/customer/order/refund-request';
  static const String orderCancellationUri =
      '/api/v1/customer/order/cancellation-reasons';
  static const String cuisineUri = '/api/v1/cuisine';
  static const String cuisineRestaurantUri = '/api/v1/cuisine/get_restaurants';
  static const String privacy_policy = 'assets/appData/privacy_policy.json';

  /// Shared Key
  static const String theme = 'theme';
  static const String token = 'multivendor_token';
  static const String COUNTRY_CODE = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userNumber = 'user_number';
  static const String userCountryCode = 'user_country_code';
  static const String notification = 'notification';
  static const String searchHistory = 'search_history';
  static const String intro = 'intro';
  static const String notificationCount = 'notification_count';
  static const String notificationIdList = 'notification_id_list';
  static const String topic = 'all_zone_customer';
  static const String zoneId = 'zoneId';
  static const String localizationKey = 'X-localization';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String earnPoint = 'stackfood_earn_point';
  static const String acceptCookies = '6ammart_accept_cookies';
  static const String cookiesManagement = 'cookies_management';
  static const String dmTipIndex = 'stackfood_dm_tip_index';

  ///Refer & Earn work flow list..
  static const dataList = [
    'Invite your friends & businesses',
    'They register eFood with special offer',
    'You made your earning !'
  ];

  /// Delivery Tips
  static List<String> tips = ['not_now', '15', '10', '20', '40', 'custom'];
  static List<String> deliveryInstructionList = [
    'Deliver to front door',
    'Deliver to the reception desk',
    'Avoid calling me',
  ];

  ///Order Status
  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String processing = 'processing';
  static const String confirmed = 'confirmed';
  static const String handover = 'handover';
  static const String pickedUp = 'picked_up';
  static const String delivered = 'delivered';
  static const String cancelled = 'canceled';

  /// Delivery Type
  static const String delivery = 'delivery';
  static const String takeAway = 'take_away';

  /// Preference Day
  static List<String?> preferenceDays = ['today', 'tomorrow'];

  /// Deep Links
  static const String yourScheme = 'StackFood';
  static const String yourHost = 'stackfood.com';

  /// Languages
  static List<LanguageModel> languages = [
    LanguageModel(
        languageName: 'عربى', countryCode: 'SA', languageCode: 'ar-SA'),
    LanguageModel(
        languageName: 'English', countryCode: 'US', languageCode: 'en-US'),
  ];
}
