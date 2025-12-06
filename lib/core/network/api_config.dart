class ApiConfig {
  static const String baseUrl = 'https://api.shift7store.com/api';

  // * Intro
  static const String intro = '$baseUrl/home/get-stores';
  static const String getStoreDetails = '$baseUrl/home/store-details';
  static const String getProduct = '$baseUrl/home/product-details';
  static const String sendProductReview = '$baseUrl/review';
  static const String search = '$baseUrl/home/search';
  static const String appVersion = '$baseUrl/app-version/get';

  // * Auth
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String verifyEmail = '$baseUrl/verify-email';
  static const String changePassword = '$baseUrl/change-password';
  static const String sentOtp = '$baseUrl/send-otp';
  static const String googleAuth = '$baseUrl/auth/google';
  static const String verifyCodeOfForgetPassword = '$baseUrl/verify-otp';
  static const String deleteAccount = '$baseUrl/delete-account';

  // * Home
  static const String bestSeller = '$baseUrl/home/best-sellers';
  static const String specialOffer = '$baseUrl/home/exclusive-offers';
  static const String newArrival = '$baseUrl/home/new-arrivals';
  static const String customTabs = '$baseUrl/home/get-custom-tab';
  static const String customTabsDetails =
      '$baseUrl/home/get-custom-tab-details';
  static const String mediaLinksDetails =
      '$baseUrl/home/get-media-link/details';
  static const String brandDetails = '$baseUrl/home/products-by-brand';
  static const String getBrandsByCategory = '$baseUrl/home/brands-by-category';
  static const String getCategoriesByBrand =
      '$baseUrl/home/categories-by-brand';
  static const String getFilteredProducts = '$baseUrl/home/products';

  // * Categories
  static String allCategories = '$baseUrl/home/get-categories';
  static String allCategoriesProducts = '$baseUrl/home/products-by-category';
  static String marketCategories = '$baseUrl/home/categories-for-parent';

  // * Fav
  static String allFav = '$baseUrl/wishlists';
  static String setFav = '$baseUrl/wishlists';

  // * Cart
  static String addToCart = '$baseUrl/cart/add';
  static String getCart = '$baseUrl/cart';
  static String updateCart = '$baseUrl/cart/update';
  static String removeFromCart = '$baseUrl/cart/remove';
  static String clearCart = '$baseUrl/cart/clear';
  static String checkout = '$baseUrl/order';
  static String getAddressList = '$baseUrl/home/address';
  static String getCartDetails = '$baseUrl/order/view';

  // * Profile
  static String getProfile = '$baseUrl/home/user/info';
  static String updateProfile = '$baseUrl/home/user/update';
  static String setLocation = '$baseUrl/home/address/store';
  static String getUserLocations = '$baseUrl/home/address';
  static String deleteLocation = '$baseUrl/home/address/delete';
  static String getSocialMedia = '$baseUrl/home/sociallink';
  static String getHelpCenter = '$baseUrl/home/questionhelpcenter';
  static String getPrivacyAndPolicy = '$baseUrl/home/privacy-and-policy';
  static String getNotifications = '$baseUrl/user-notification';
  static String logOut = '$baseUrl/logout';
  static String seenNotifications = '$baseUrl/user-notification';
  static String getMyOrders = '$baseUrl/profile/orders';
}
