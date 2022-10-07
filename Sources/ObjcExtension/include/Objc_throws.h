//
//  Objc_throws.h
//  
//
//  Created by 庄黛淳华 on 2019/11/9.
//  Copyright © 2019. All rights reserved.
//

#ifndef Objc_throws_h
#define Objc_throws_h

@import Foundation;

static inline void objc_catch(void (NS_NOESCAPE ^ _Nonnull tryBlock)(void), void(NS_NOESCAPE ^ _Nullable catchBlock)(NSException * _Nonnull e)) {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        if (catchBlock) {
            catchBlock(exception);
        }
    }
}

#endif /* Objc_throws_h */
