//
//  Constants.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/8/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import Foundation


/*Category*/
let CATEGORIES=["technology","travelling","fashion","pet","food","others"]
let CATEGORIES_UPPERCASE=["Technology","Travelling","Fashion","Pet","Food","Others"]


/*Size*/
let HEADER_CELL_HEIGHT:CGFloat                  = 60.0

/* Comment */
let PF_COMMENT_CLASS_NAME				= "Comment"					//	Class name
let PF_COMMENT_USER						= "user"					//	Pointer to User Class
let PF_COMMENT_GROUPID					= "groupId"                 //	String
let PF_COMMENT_TEXT						= "text"					//	String
let PF_COMMENT_PICTURE					= "picture"                 //	File
let PF_COMMENT_VIDEO					= "video"                   //	File
let PF_COMMENT_CREATEDAT				= "createdAt"               //	Date

/* Messages*/
let PF_MESSAGES_CLASS_NAME				= "Messages"				//	Class name
let PF_MESSAGES_USER					= "user"					//	Pointer to User Class
let PF_MESSAGES_GROUPID					= "groupId"                 //	String
let PF_MESSAGES_DESCRIPTION				= "description"             //	String
let PF_MESSAGES_LASTUSER				= "lastUser"				//	Pointer to User Class
let PF_MESSAGES_LASTMESSAGE				= "lastMessage"             //	String
let PF_MESSAGES_COUNTER					= "counter"                 //	Number
let PF_MESSAGES_UPDATEDACTION			= "updatedAction"           //	Date

/* Notification */
let NOTIFICATION_APP_STARTED			= "NCAppStarted"
let NOTIFICATION_USER_LOGGED_IN			= "NCUserLoggedIn"
let NOTIFICATION_USER_LOGGED_OUT		= "NCUserLoggedOut"

/* Installation */
let PF_INSTALLATION_CLASS_NAME			= "_Installation"           //	Class name
let PF_INSTALLATION_OBJECTID			= "objectId"				//	String
let PF_INSTALLATION_USER				= "user"					//	Pointer to User Class

//---------------------------------------------------------------------------------------


/* User */
let PF_USER_CLASS_NAME					= "_User"                   //	Class name
let PF_USER_OBJECTID					= "objectId"				//	String
let PF_USER_USERNAME					= "username"				//	String
let PF_USER_PASSWORD					= "password"				//	String
let PF_USER_EMAIL						= "email"                   //	String
let PF_USER_FACEBOOKID					= "facebookId"              //	String
let PF_USER_PICTURE						= "icon"                    //	File


/* Friend */
let PF_FRIEND_CLASS_NAME				= "Friend"                  //	Class name
let PF_FRIEND_USER                      = "user"					//	Pointer to User Class
let PF_FRIEND_FRIEND                    = "friend"			        //	Pointer to User Class

/* Post */
let PF_POST_CLASS_NAME				   = "Post"                    //	Class name
let PF_POST_POSTER                     = "poster"				   //	Pointer to User Class
let PF_POST_VOTE1                      = "vote1"			       //	number
let PF_POST_VOTE2                      = "vote2"			       //	number
let PF_POST_TOTALVOTES                 = "totalVotes"			     //	number
let PF_POST_ISPRIVATE                  = "isPrivate"			     //	Boolean
let PF_POST_TITLE                      = "title"			     //	String
let PF_POST_CATEGORY                   = "category"			     //	String
let PF_POST_IMAGE1FILE                 = "image1File"			       //	File
let PF_POST_IMAGE2FILE                 = "image2File"			       //	File
let PF_POST_CREATEDAT                  = "createdAt"			       //	Date
let PF_POST_UPDATEDAT                  = "updatedAt"			       //	Date


/* Vote */
let PF_VOTE_CLASS_NAME			       = "Vote"                    //	Class name
let PF_VOTE_CHOICE                     = "choice"					 //	Number
let PF_VOTE_VOTER                      = "voter"					//	Pointer to User Class
let PF_VOTE_POSTID                      = "postId"					//	String
let PF_VOTE_CREATEDAT                  = "createdAt"			       //	Date



/* FriendsRequest */
let PF_FRIENDSREQUEST_CLASS_NAME	  = "FriendsRequest"    //	Class name
let PF_FRIENDSREQUEST_FROMUSER        = "fromUser"			//	Pointer to User Class
let PF_FRIENDSREQUEST_TOUSER          = "toUser"		    //	Pointer to User Class
let PF_FRIENDSREQUEST_MESSAGE         = "message"            // String
let PF_FRIENDSREQUEST_CREATEDAT       = "createdAt"			//	Date

/*Parse Notification */
let PF_NOTIFICATION_CLASS_NAME	    = "Notifications"    //	Class name
let PF_NOTIFICATION_FROMUSER        = "fromUser"		//	Pointer to User Class
let PF_NOTIFICATION_TOUSER          = "toUser"		    //	Pointer to User Class
let PF_NOTIFICATION_POST            = "post"            //  Pointer to post Class
let PF_NOTIFICATION_MESSAGETYPE     = "messageType"     //  String
let PF_NOTIFICATION_CREATEDAT       = "createdAt"			//	Date
