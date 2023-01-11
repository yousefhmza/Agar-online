class EndPoints {
  // Auth
  static const String login = "login";
  static const String signup = "register";
  static const String getCurrentUser = "profile";
  static const String editProfile = "edit-profile";
  static const String deleteAccount = "remove-account";
  static const String forgetPassword = "forget-password";
  static const String socialAuth = "social-login";

  // Home
  static const String getHomeData = "home";

  // Categories
  static const String getAllCategories = "all-categories";
  static const String getSubcategories = "sub_category";
  static const String getSubSubCategories = "sub_sub_category";

  // Ads
  static const String featuredAds = "property-feature";
  static const String getLatestAds = "latest-ads";
  static const String fetchAdDetails = "property";
  static const String addAd = "add-property";
  static const String editAd = "edit-property";
  static const String getAdTypes = "ad-for";
  static const String getMyAds = "my-properties";
  static const String deleteAd = "delete-ad";
  static const String deleteAdImage = "delete-ad-image";
  static const String getSetting = "setting";
  static const String getAdsBySubSubCategory = "properties-sub-category";

  // Search
  static const String getSearch = "ads-search";

  // Regions
  static const String getCities = "cities";
  static const String getCityAreas = "areas";
  static const String getSubAreas = "sub-areas";

  // Favourites
  static const String getWishList = "wishlist";
  static const String addToFavourites = "add-wishlist";
  static const String removeFromFavourites = "remove-wishlist";

  // HelpCenter
  static const String helpCenter = "Help-center";

  // Chat
  static const String getAllChats = "chat-list";
  static const String getChatHistory = "chat-history";
  static const String startChat = "create-chat";
  static const String sendMessage = "replay-chat";

  // Reports
  static const String reportAd = "report";
  static const String reportUser = "report-user";

  // Block
  static const String getBlockList = "block-list";
  static const String blockUser = "block";
  static const String unblockUser = "unblock";
}
