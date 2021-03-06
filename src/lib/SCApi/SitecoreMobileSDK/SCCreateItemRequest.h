//
//  SCCreateItemRequest.h
//  SCCreateItemRequest
//
//  Created on 04/02/2012.
//  Copyright 2012. Sitecore. All rights reserved.
//

#import "SCReadItemsRequest.h"

#import <Foundation/Foundation.h>

/**
 The SCCreateItemRequest contains the set of params of the creating item.
 It used for [SCApiSession createItemsOperationWithRequest:] method.
 This class is inherited from SCReadItemsRequest class whose fields is used to search item
 wich will be a parent for created item.
 */
@interface SCCreateItemRequest : SCReadItemsRequest

/**
 The display name of creating item ( obligatory parameter ).
 */
@property ( nonatomic ) NSString* itemName;

/**
 The template of creating item ( obligatory parameter ).
 */
@property ( nonatomic ) NSString* itemTemplate;

/**
 The dictionary of fields raw values by fields names, the item with specified fields will be created.
 */
@property ( nonatomic ) NSDictionary* fieldsRawValuesByName;

@end
