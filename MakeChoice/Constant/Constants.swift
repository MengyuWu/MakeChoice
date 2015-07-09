//
//  Constants.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/8/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import Foundation

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
let PF_POST_CHOICE                     = "choice"			     //	Pointer to Choice Class
let PF_POST_VOTES                      = "votes"			     //	number
let PF_POST_TOTALVOTES                 = "totalVotes"			     //	number
let PF_POST_ISPRIVATE                  = "isPrivate"			     //	Boolean
let PF_POST_TITLE                      = "title"			     //	String

/* Choice */
let PF_CHOICE_CLASS_NAME			   = "Choice"                    //	Class name
let PF_CHOICE_IMAGE                    = "image"					 //	File

/* Vote */
let PF_VOTE_CLASS_NAME			       = "Vote"                    //	Class name
let PF_VOTE_CHOICE                     = "choice"					 //	Pointer to Choice Class
let PF_VOTE_VOTER                      = "voter"					//	Pointer to User Class

