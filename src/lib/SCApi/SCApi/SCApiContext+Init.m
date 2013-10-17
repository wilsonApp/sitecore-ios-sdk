#import "SCApiContext+Init.h"

#import "SCRemoteApi.h"

#import "SCWebApiUrlBuilder.h"
#import "SCWebApiVersionResolver.h"
#import "SCExtendedApiContext+Private.h"
#import "SCExtendedApiContext.h"
#import "SCExtendedApiContext+Init.h"

#import "SCGenericRecordCache.h"
#import "SCInMemoryRecordStorageBuilder.h"
#import "SCPersistentStorageBuilder.h"

#import "SCCacheSettings.h"

#import "SCApiMacro.h"

@interface SCExtendedApiContext (MainContext)

@property ( nonatomic, weak ) SCApiContext *mainContext;

@end

@implementation SCApiContext (Init)

@dynamic itemsCache;
@dynamic api;
@dynamic extendedApiContext;

-(id)initWithRemoteApi:( SCRemoteApi* )api_
            itemsCache:( id<SCItemRecordCacheRW> )itemsCache_
    notificationCenter:( NSNotificationCenter* )notificationCenter
{
    self = [ super init ];
    {
        self.api = api_;
        self.itemsCache = itemsCache_;
        
        SCExtendedApiContext *extendedContext = [ [ SCExtendedApiContext alloc ] initWithRemoteApi: api_
                                                                                        itemsCache: itemsCache_
                                                                                notificationCenter: notificationCenter ];
        
        self.extendedApiContext = extendedContext;
        self.extendedApiContext.mainContext = self;
    }

    return self;
}

-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_
{
    return [ self initWithHost: host_
                         login: login_
                      password: password_
                       version: SCWebApiV1 ];
}

-(id)initWithHost:( NSString* )host_
            login:( NSString* )login_
         password:( NSString* )password_
          version:( SCWebApiVersion )version_
{
    NSString* webApiVersion = [ SCWebApiVersionResolver webApiVersionToString: version_ ];
    SCWebApiUrlBuilder* urlBuilder = [ [ SCWebApiUrlBuilder alloc ] initWithVersion: webApiVersion ];
    
    SCRemoteApi* api_ =
    [ [ SCRemoteApi alloc ] initWithHost: host_
                                   login: login_
                                password: password_
                              urlBuilder: urlBuilder ];
    
    id<SCItemRecordStorageBuilder> storageBuilder = nil;
#if USE_IN_MEMORY_CACHE
    {
        storageBuilder = [ SCInMemoryRecordStorageBuilder new ];
    }
#else
    SCPersistentStorageBuilder* persistentBuilder = nil;
    {
        SCCacheSettings* cacheSettings = [ SCCacheSettings new ];
        {
            cacheSettings.host = host_;
            cacheSettings.userName = login_;
            cacheSettings.cacheDbVersion = @"1";
        }

        
        NSString* databaseNameBase = [ cacheSettings getFullNameForCacheDatabaseInDocumentsDir ];
        
        persistentBuilder =
        [ [ SCPersistentStorageBuilder alloc ] initWithDatabasePathBase: databaseNameBase
                                                               settings: cacheSettings ];
        storageBuilder = persistentBuilder;
    }
#endif

    
    
    id<SCItemRecordCacheRW> itemsCache_ = [ [ SCGenericRecordCache alloc ] initWithStorageBuilder:storageBuilder ];

    SCApiContext* result = [ self initWithRemoteApi: api_
                                         itemsCache: itemsCache_
                                 notificationCenter: [ NSNotificationCenter defaultCenter ] ];
    
#if !USE_IN_MEMORY_CACHE
    persistentBuilder.apiContext = self.extendedApiContext;
#endif
    
    return result;
}

-(id)initWithHost:( NSString* )host_
{
    return [ self initWithHost: host_
                         login: nil
                      password: nil
                       version: SCWebApiV1 ];
}

@end
