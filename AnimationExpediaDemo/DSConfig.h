//
//  DSConfig.h
//  DistributionProject
//
//  Created by liujianzhong on 15/7/13.
//  Copyright © 2015年 T.E.N_. All rights reserved.
//

#ifndef DSConfig_h
#define DSConfig_h

/**屏幕尺寸*/
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height
/**封装颜色*/
#define DSColorMake(r, g, b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define DSColorAlphaMake(r, g, b, a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define DSColorFromHex(rgb)     [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]
#define DSColorAlphaFromHex(rgb,a)     [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:a]
/**设置主题色*/
#define DSColor DSColorFromHex(0x0D94E5) //蓝色风格主题色调00ad88
#define DSNavi DSColorFromHex(0xffffff) //navigation的颜色
#define DSRedColor DSColorFromHex(0xe36062)//红色风格主题色调
#define DSGrayColor DSColorFromHex(0x99999c)//灰色字体
#define DSGrayColor3 DSColorFromHex(0x333333)//灰色字体
#define DSGrayColor6 DSColorFromHex(0x666666)//灰色字体
#define DSGrayColor9 DSColorFromHex(0x999999)//灰色字体

#define DSBackColor DSColorFromHex(0xEFEFF4)//背景浅灰
#define DSBackLightColor DSColorFromHex(0xf4f4f4)//背景浅灰
#define DSLineSepratorColor DSColorFromHex(0xE3E3E8)//分割线颜色

#define DSBlackColor DSColorFromHex(0x333333)//浅黑色
/**判断系统版本*/
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#endif /* DSConfig_h */
