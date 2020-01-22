const int LOG_LEVEL = 0;
const int APP_ID = 1;


//const String IM_SERVER_IP = "192.168.10.192";
//const String DOMAIN = "myopenfire";
//const String BASE_SERVER_URL="http://file.gycdn1.com:2086/yinlibao_server";
//正式环境
const String IM_SERVER_IP = "119.28.223.34";
const String DOMAIN = "liberty";
const String BASE_SERVER_URL="http://150.109.54.174:8080/yinlibao_server";

//const String IM_SERVER_IP = "192.168.10.195";
//const String DOMAIN = "desktop-4q8bd96";

//const String BASE_SERVER_URL="http://192.168.10.191:5168";
//const String BASE_SERVER_URL="http://192.168.10.195:5168/yinlibao_server";
//const String BASE_SERVER_URL="http://file.gycdn1.com:2086/yinlibao_server";


const int PORT = 5222;
const int RESEND_MESSAGE_TIME=5;
const String CONFERENCE = "@conference.$DOMAIN";
const String DEFAULT_HEADER = 'assets/images/app_logo.png';

const String GET_VERSION_URL = "$BASE_SERVER_URL/client/getApkLatestVersion?";
const String GET_TOPICS_URL="$BASE_SERVER_URL/group/getTopics?";
const String UPLOAD_URL="$BASE_SERVER_URL/upload/upload";
const String UPLOAD_HEADER_URL="$BASE_SERVER_URL/upload/uploadHeader";
const String UPLOAD_OFFICIAL_ACCOUNT_HEADER_URL="$BASE_SERVER_URL/upload/uploadOfficialAccountHeader";
const String UPLOAD_VOICE_URL="$BASE_SERVER_URL/upload/uploadVoice";

//申请公众号
const String APPLY_OFFICIAL_ACCOUNT_URL="$BASE_SERVER_URL/officialAccount/applyOfficialAccount?";

//修改公众号
const String EDIT_OFFICIAL_ACCOUNT_URL="$BASE_SERVER_URL/officialAccount/editOfficialAccount?";
//关注公众号
const String FOLLOW_OFFICIAL_ACCOUNT_URL="$BASE_SERVER_URL/officialAccount/followOfficialAccount?";
//关注公众号
const String UNFOLLOW_OFFICIAL_ACCOUNT_URL="$BASE_SERVER_URL/officialAccount/unfollowOfficialAccount?";
//获取关注公众号
const String GET_FOLLOW_OFFICIAL_ACCOUNT_URL="$BASE_SERVER_URL/officialAccount/getFollowOfficialAccountListByUserId?";
//获取公众号粉丝
const String GET_OFFICIAL_ACCOUNT_FOLLOWERS_URL="$BASE_SERVER_URL/officialAccount/getFollowerListByOfficialAccountId?";
//获取关注公众号文章
const String GET_FOLLOW_OFFICIAL_ACCOUNT_TOPICS_URL="$BASE_SERVER_URL/officialAccount/getFollowOfficialAccountTopicByUserId?";
//查找公众号文章
const String SEARCH_OFFICIAL_ACCOUNT_TOPICS_URL="$BASE_SERVER_URL/officialAccount/searchOfficialAccountTopic?";
//根据文章id获取关注公众号文章
const String GET_OFFICIAL_ACCOUNT_TOPIC_URL="$BASE_SERVER_URL/officialAccount/getOfficialAccountTopicByTopicId?";
//获取关注公众号文章
const String GET_USER_OFFICIAL_ACCOUNTS_URL="$BASE_SERVER_URL/officialAccount/getUserOfficialAccountListByUserId?";
//ADD公众号文章
const String ADD_OFFICIAL_ACCOUNT_TOPIC_URL="$BASE_SERVER_URL/officialAccount/addOfficialAccountTopic?";
//增加群公告
const String ADD_GROUP_BULLETIN_URL="$BASE_SERVER_URL/group/addGroupBulletin?";
//获取群公告
const String GET_GROUP_BULLETIN_URL="$BASE_SERVER_URL/group/getGroupBulletin?";
//获取群公告
const String SEARCH_OFFICIAL_ACCOUNT_URL="$BASE_SERVER_URL/officialAccount/searchOfficialAccount?";
//搜索用户
const String SEARCH_USER_NAME_URL="$BASE_SERVER_URL/user/searchUser?";
//通过电话得到账号
const String GET_USERNAME_BY_PHONE_URL="$BASE_SERVER_URL/user/getUsernameByPhone?";
//发送手机短信
const String SEND_PHONE_SMS_URL="$BASE_SERVER_URL/user/sendSms?";
//验证手机短信
const String VERIFY_PHONE_SMS_URL="$BASE_SERVER_URL/user/verifySMS?";
//用户重置密码
const String RESET_USER_PASSWORD_URL="$BASE_SERVER_URL/user/resetUserPassword?";
//
const String CHECK_SERVER_URL="$BASE_SERVER_URL/user/checkConnect?";
//通过电话生成账号
const String GENERATE_ACCOUNT_BY_PHONE_URL="$BASE_SERVER_URL/user/generateUsernameByPhone?";
//获取token
const String LOGIN_FOR_TOKEN_URL="$BASE_SERVER_URL/user/login?";
//获取用户详情
const String GET_USER_BY_JID_URL="$BASE_SERVER_URL/user/getUserByUsername?";
//编辑用户详情
const String EDIT_USER_URL="$BASE_SERVER_URL/user/editUser";
//编辑用户详情
const String SEARCH_GROUP_URL="$BASE_SERVER_URL/group/searchPublicGroup?";
//获取群信息详情
const String GET_GROUP_BY_NAME_URL="$BASE_SERVER_URL/group/getGroupByName?";


