# This is obsolete project.
Obsolete! This project has been replace to "ActivityAction" project. No longer update and support.

#Daijirin ActionMenu Plugin

Send to "Daijirin", "Daijisen", "Wisdom" and "Safari".

![](http://moreinfo.thebigboss.org/moreinfo/actionmenudaijirin1.png)
![](http://moreinfo.thebigboss.org/moreinfo/actionmenudaijirin3.png)

##ChangeLog
1.16

* [ADD] FastEver option
* [FIX] target UIView of UIActionSheet

1.15

* [ADD] GoogleTranslate option

1.14

* [ADD] Midori Dictionary option

1.13

* [ADD] Excite option

1.12

* [ADD] Kojien option
* [FIX] Daijisen crash issue
* [FIX] tiny memory leak

1.11

* [ADD] many options
* [MOD] Daijisen.png

1.4

* [ADD] ALC[origin word] option. ( thanks @Sakurina )
* [MOD] menu available conditions.

1.3

* [ADD] EBPocket(Professional) option.
* [MOD] default behavior.

1.2.2-2

* [MOD] default behavior.

1.2.2

* [FIX] implement UIActionSheet delegate method class issue.

1.2.1

* bug fix.
* change linkage-app icons like Apple.

1.2

* add Daijisen(jp/en Dic) option.
* change button name Google to Safari (available Yahoo! and Bing. (Selected SearchEngine of Safari))
* excluding the return URL Scheme exception of mobilesafari. However, return http scheme behavior is reload page. So I recommended use for AppSwitcher.
* SheetStyle option exception handling in "ch.reeder".

1.1.1

* fix crash on iPad.
* add launch app icons. (Preference icons)

1.1

* remove AlertRow option.
* add ActionSheet option.
* add EOW (Eijiro on the Web(AppStore)) option

1.0

* add select option (Wisdom and Google).
* add AlertRow option.

---BigBoss repo release  

0.5

* PreferenceLoader -> ActionMenu PreferenceBundle. change pkgname "ActionMenu" to "Action Menu".

0.4-2

* add . (add condition url scheme != nil )

0.4

* add urlscheme(except mobilesafari).
* enable/disable switch in Preference.app(depend preferenceloader).

0.3

* available iPad. ( fix crash )

0.2

* available icon style.

0.1

* initial release.

##Special Thanks

Simon Blommegard (SBTableAlert)  
Yanik Magnan @Sakurina (dynamic enable PSSwitchCell on PreferenceLoader)  
Ryan Petrich @rpetrich (ActionSheet's delegate instance release timing issue)  
moyashi @hitoriblog (applicationOpenURL method)  
tom_go @tom_go (x-web-search:///? URL Scheme)

## License

Simplified BSD License ( "2-Clause BSD License" or "FreeBSD License" )

Copyright (C) 2010-2011 r_plus All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS "AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
