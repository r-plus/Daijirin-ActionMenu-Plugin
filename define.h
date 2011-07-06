#define PREFERENCE_PATH @"/var/mobile/Library/Preferences/jp.r-plus.amdaijirin.plist"
#define URL_SCHEME_BLACKLIST (![identifier isEqualToString:@"com.apple.Maps"] && ![identifier isEqualToString:@"com.apple.iBooks"] && ![identifier isEqualToString:@"com.apple.mobilesafari"])

#define DAIJIRIN_SCHEME_URL @"mkdaijirin://jp.monokakido.DAIJIRIN/search?text="
#define DAIJISEN_SCHEME_URL @"daijisen:operation=searchStartsWith;keyword="
#define WISDOM_SCHEME_URL @"mkwisdom://jp.monokakido.WISDOM/search?text="
#define EOW_SCHEME_URL @"eow://search?query="
#define EBPOCKET_SCHEME_URL @"ebpocket://search?text="
#define SAFARI_SCHEME_URL @"x-web-search:///?"
#define ALC_ORIGIN_OF_WORD_SCHEME_URL @"http://www.google.com/gwt/x?u=http://home.alc.co.jp/db/owa/etm_sch?instr="
#define DICTIONARYCOM_SCHEME_URL @"dcom://dictionary/"
#define LONGMAN_EE_SCHEME_URL @"ldoce://"
#define LONGMAN_EJ_SCHEME_URL @"lejdict://"
#define KOTOBA_SCHEME_URL @"kotoba://dictionary?search="
#define POCKET_PROGRESSIVE_EJ_SCHEME_URL @"pocketprogressivee://"
#define GURUDIC_SCHEME_URL @"gurudic:"
#define RUIGO_SCHEME_URL @"mkruigo://jp.monokakido.RUIGO/search?text="

