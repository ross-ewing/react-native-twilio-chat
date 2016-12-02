//
//  RCTConvert+TwilioChatClient.m
//  TwilioIPExample
//
//  Created by Brad Bumbalough on 5/31/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTConvert+TwilioChatClient.h"
#import <RCTUtils.h>

@implementation RCTConvert (TwilioChatClient)

RCT_ENUM_CONVERTER(TCHClientSynchronizationStatus,(@{
                                                      @"Started" : @(TCHClientSynchronizationStatusStarted),
                                                      @"ChannelsListCompleted" : @(TCHClientSynchronizationStatusChannelsListCompleted),
                                                      @"Completed" : @(TCHClientSynchronizationStatusCompleted),
                                                      @"Failed" : @(TCHClientSynchronizationStatusFailed),
                                                      }), TCHClientSynchronizationStatusStarted, integerValue)


RCT_ENUM_CONVERTER(TCHChannelSynchronizationStatus,(@{
                                                      @"None" : @(TCHChannelSynchronizationStatusNone),
                                                      @"Identifier" : @(TCHChannelSynchronizationStatusIdentifier),
                                                      @"Metadata" : @(TCHChannelSynchronizationStatusMetadata),
                                                      @"All" : @(TCHChannelSynchronizationStatusAll),
                                                      @"Failed" : @(TCHChannelSynchronizationStatusFailed),
                                                      }), TCHChannelSynchronizationStatusNone, integerValue)

RCT_ENUM_CONVERTER(TCHChannelStatus,(@{
                                       @"Invited" : @(TCHChannelStatusInvited),
                                       @"Joined" : @(TCHChannelStatusJoined),
                                       @"NotParticipating" : @(TCHChannelStatusNotParticipating),
                                      }), TCHChannelStatusInvited, integerValue)

RCT_ENUM_CONVERTER(TCHChannelType,(@{
                                     @"Public" : @(TCHChannelTypePublic),
                                     @"Private" : @(TCHChannelTypePrivate),
                                     }), TCHChannelTypePublic, integerValue)

RCT_ENUM_CONVERTER(TCHUserInfoUpdate,(@{
                                        @"FriendlyName" : @(TCHUserInfoUpdateFriendlyName),
                                        @"Attributes" : @(TCHUserInfoUpdateAttributes),
                                        @"ReachabilityOnline": @(TCHUserInfoUpdateReachabilityOnline),
                                        @"ReachabilityNotifiable": @(TCHUserInfoUpdateReachabilityNotifiable),
                                        }), TCHUserInfoUpdateFriendlyName, integerValue)

RCT_ENUM_CONVERTER(TCHClientSynchronizationStrategy,(@{
                                                       @"All" : @(TCHClientSynchronizationStrategyAll),
                                                       @"ChannelsList" : @(TCHClientSynchronizationStrategyChannelsList),
                                                       }), TCHClientSynchronizationStrategyAll, integerValue)

RCT_ENUM_CONVERTER(TCHLogLevel,(@{
                                  @"Fatal" : @(TCHLogLevelFatal),
                                  @"Critical" : @(TCHLogLevelCritical),
                                  @"Warning" : @(TCHLogLevelWarning),
                                  @"Info" : @(TCHLogLevelInfo),
                                  @"Debug" : @(TCHLogLevelDebug),
                                }), TCHLogLevelFatal, integerValue)


+ (NSDictionary *)TwilioAccessManager:(TwilioAccessManager *)accessManager {
  if (!accessManager) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"identity": accessManager.identity,
           @"token": accessManager.token,
           @"isExpired": @(accessManager.isExpired),
           @"expirationDate": @(accessManager.expirationDate.timeIntervalSince1970 * 1000)
           };
}

+ (NSDictionary *)TwilioChatClient:(TwilioChatClient *)client {
  if (!client) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"userInfo": [self TCHUserInfo:client.userInfo],
           @"synchronizationStatus": @(client.synchronizationStatus),
           @"version": client.version,
           @"isReachabilityEnabled": @(client.isReachabilityEnabled)
           };
}


+ (NSDictionary *)TCHUserInfo:(TCHUserInfo *)userInfo {
  if (!userInfo) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"identity": userInfo.identity,
           @"friendlyName": userInfo.friendlyName,
           @"attributes": RCTNullIfNil(userInfo.attributes),
           @"isOnline": @(userInfo.isOnline),
           @"isNotifiable": @(userInfo.isNotifiable)
           };
}

+ (NSDictionary *)TCHMessage:(TCHMessage *)message {
  if (!message) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"sid": message.sid,
           @"index": message.index,
           @"author": message.author,
           @"body": message.body,
           @"timestamp": message.timestamp,
           @"timestampAsDate": @(message.timestampAsDate.timeIntervalSince1970 * 1000),
           @"dateUpdated": message.dateUpdated,
           @"dateUpdatedDate": @(message.dateUpdatedAsDate.timeIntervalSince1970 * 1000),
           @"lastUpdatedBy": message.lastUpdatedBy,
           @"attributes": RCTNullIfNil(message.attributes)
           };
}

+ (NSDictionary *)TCHMember:(TCHMember *)member {
  if (!member) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"userInfo": [RCTConvert TCHUserInfo:member.userInfo],
           @"lastConsumedMessageIndex": RCTNullIfNil(member.lastConsumedMessageIndex),
           @"lastConsumptionTimestamp": RCTNullIfNil(member.lastConsumptionTimestamp)
           };
}

+ (NSDictionary *)TCHChannel:(TCHChannel *)channel {
  if (!channel) {
    return RCTNullIfNil(nil);
  }
  return @{
           @"sid": channel.sid,
           @"friendlyName": channel.friendlyName,
           @"uniqueName": channel.uniqueName,
           @"status": @(channel.status),
           @"type": @(channel.type),
           @"attributes": RCTNullIfNil(channel.attributes),
           @"synchronizationStatus": @(channel.synchronizationStatus),
           @"dateCreated": channel.dateCreated,
           @"dateUpdated": channel.dateUpdated,
           @"createdBy": channel.createdBy
           };
}

+ (NSArray *)TCHMembers:(NSArray<TCHMember *>*)members {
  if (!members) {
    return RCTNullIfNil(nil);
  }
  NSMutableArray *response = [NSMutableArray array];
  for (TCHMember *member in members) {
    [response addObject:[self TCHMember:member]];
  }
  return response;
}

+ (NSArray *)TCHMessages:(NSArray<TCHMessage *> *)messages {
  if (!messages) {
    return RCTNullIfNil(nil);
  }
  NSMutableArray *response = [NSMutableArray array];
  for (TCHMessage *message in messages) {
    [response addObject:[self TCHMessage:message]];
  }
  return response;
}

+ (NSData *)dataWithHexString:(NSString *)hex {
  // Source:  https://opensource.apple.com/source/Security/Security-55471.14.18/libsecurity_transform/NSData+HexString.m
  char buf[3];
  buf[2] = '\0';
  NSAssert(0 == [hex length] % 2, @"Hex strings should have an even number of digits (%@)", hex);
  unsigned char *bytes = malloc([hex length]/2);
  unsigned char *bp = bytes;
  for (CFIndex i = 0; i < [hex length]; i += 2) {
      buf[0] = [hex characterAtIndex:i];
      buf[1] = [hex characterAtIndex:i+1];
      char *b2 = NULL;
      *bp++ = strtol(buf, &b2, 16);
      NSAssert(b2 == buf + 2, @"String should be all hex digits: %@ (bad digit around %d)", hex, i);
  }

  return [NSData dataWithBytesNoCopy:bytes length:[hex length]/2 freeWhenDone:YES];
}


@end