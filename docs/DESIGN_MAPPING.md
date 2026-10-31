# Pixso 页面与代码对应表

来源：[Eateries food app ui kit](https://pixso.cn/app/design/xsbGqqr2z_11gAvEsroxPA)。通过 MCP 读取两个分类，各 48 个 FRAME。节点边界与原始名称保存在 [nodes.json](design/nodes.json)，各画面的文字在 [texts.json](design/texts.json)。下表中的编号同时对应截图文件名。

| 编号 | 原稿画面 | 浅色节点 | 深色节点 | 代码模块（lib/features/） |
| --- | --- | --- | --- | --- |
| 01 | Splash Screen 1 | `1:156` | `7:5202` | auth.dart |
| 02 | Splash Screen  2 | `1:23` | `7:5192` | auth.dart |
| 03 | Splash Screen  3 | `1:817` | `7:5216` | auth.dart |
| 04 | Sign in 1 | `1:2116` | `7:7236` | auth.dart |
| 05 | Sign in 2 | `1:2152` | `7:7254` | auth.dart |
| 06 | Forgot password | `1:2290` | `7:7281` | auth.dart |
| 07 | Reset email | `1:2429` | `7:7290` | auth.dart |
| 08 | Sign in 3 | `1:2270` | `7:7270` | auth.dart |
| 09 | Sign up  1 | `1:2551` | `7:11702` | auth.dart |
| 10 | Sign up  2 | `1:2588` | `7:11719` | auth.dart |
| 11 | Login by Phone number | `1:2817` | `7:7626` | auth.dart |
| 12 | Confirm phone number | `1:2834` | `7:7635` | auth.dart |
| 13 | Enter adress | `1:3076` | `7:8058` | auth.dart |
| 14 | Type locations | `1:3093` | `7:8064` | auth.dart |
| 15 | home page 1 | `1:3517` | `7:8961` | discover.dart |
| 16 | home page 2 | `1:3619` | `7:8991` | discover.dart |
| 17 | home page 3 | `1:3680` | `7:9017` | discover.dart |
| 18 | home page 4 | `1:3726` | `7:9049` | discover.dart |
| 19 | Featue partner 1 | `1:5489` | `7:10402` | discover.dart |
| 20 | Featue partner 2 | `1:5514` | `7:10418` | discover.dart |
| 21 | Single resturent 1 | `5:3743` | `7:11000` | orders.dart |
| 22 | Single resturent 2 | `5:3807` | `7:11037` | orders.dart |
| 23 | add to order | `3:2655` | `7:11418` | orders.dart |
| 24 | your order | `3:2778` | `7:11431` | orders.dart |
| 25 | add payment method | `3:2724` | `7:11440` | orders.dart |
| 26 | Filters/food type 1 | `3:2995` | `7:12303` | discover.dart |
| 27 | Filters/food type 2 | `3:3046` | `7:12346` | discover.dart |
| 28 | Filters/food type 3 | `3:3117` | `7:12385` | discover.dart |
| 29 | Filters/food type 4 | `3:3178` | `7:12422` | discover.dart |
| 30 | Search Restaurants | `3:3478` | `7:12764` | discover.dart |
| 31 | Search food | `3:3531` | `7:12784` | discover.dart |
| 32 | Searching food | `3:3656` | `7:12835` | discover.dart |
| 33 | Search results 1 | `3:3605` | `7:12840` | discover.dart |
| 34 | Search results 2 | `3:3628` | `7:12851` | discover.dart |
| 35 | Your orders | `5:4202` | `7:13918` | orders.dart |
| 36 | Your orders | `5:4243` | `7:13935` | orders.dart |
| 37 | Order msg | `5:4289` | `7:13944` | orders.dart |
| 38 | Account settings | `7:4161` | `7:14193` | account.dart |
| 39 | Profile settings | `7:4206` | `7:14237` | account.dart |
| 40 | Change password | `7:4229` | `7:14257` | account.dart |
| 41 | Payment method | `7:4514` | `7:14277` | account.dart |
| 42 | Card list | `7:4536` | `7:14299` | account.dart |
| 43 | Locations | `7:4572` | `7:14335` | account.dart |
| 44 | Add social accounts | `7:4601` | `7:14363` | account.dart |
| 45 | Refer to friends | `7:4744` | `7:14390` | account.dart |
| 46 | Share link/Popup | `7:4810` | `7:14447` | account.dart |
| 47 | FAQS | `7:4910` | `7:14531` | account.dart |
| 48 | Browse foods | `7:5035` | `7:15040` | discover.dart |

主要原稿参考图保留在 design/01.png、04.png、15.png、21.png、23.png、24.png、26.png、38.png、45.png、47.png。这些是 Pixso 原稿导出，与 screenshots/ 中的运行截图分开保存。

主色 #FD6920；浅色背景 #FFFFFF；深色背景 #1F1F1F；Manrope 字体。插画、食物图、头像等从对应子节点导出，再转为 WebP；应用没有使用整屏原稿替代原生组件。

