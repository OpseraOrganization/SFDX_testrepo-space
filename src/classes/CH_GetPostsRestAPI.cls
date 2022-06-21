/****************************************
* Class Name : GetPostsRestAPI 
* Created Date: 01 November 2021
* Created By : Flavio Toscano
* Description : To make custom rest API call to get @mention Posts (FeedItems & FeedComments)
************/
@RestResource(urlMapping='/api/GetPosts/*')
global with sharing class CH_GetPostsRestAPI {
	
	global class ResponseWrapper{
		global String objectName{get;set;}
		global String id{get;set;}
		global String mentionType{get;set;}
		global String mention{get;set;}
		global String mentionId{get;set;}
		global ResponseWrapper(String sObjectName, String sId, String sMentionType, String sMention, String sMentionId){
			this.objectName = sObjectName;
			this.id = sId;
			this.mentionType = sMentionType;
			this.mention = sMention;
			this.mentionId = sMentionId;
		}
	}	
	
	@HttpGet
	global static List<ResponseWrapper> doGet() {
		List<ResponseWrapper> responseWrap = new List<ResponseWrapper>();
		
		System.RestResponse res = System.RestContext.response;
		res.headers.put('Content-Type', 'application/json');
		
		Map<String,String> paramsMap = RestContext.request.params;
		
		String feedId = paramsMap.containsKey('feedId') ? paramsMap.get('feedId') : null; //5003h00000JK8XZAA1
		if(feedId != NULL){
			try{
				ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.getFeedElement(null, feedId);
				List<ConnectApi.MessageSegment> messageSegments = feedElement.body.messageSegments;
				for (ConnectApi.MessageSegment messageSegment : messageSegments) {
					if (messageSegment instanceof ConnectApi.MentionSegment) {
						ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) messageSegment;
						responseWrap.add(new ResponseWrapper('CaseFeed', feedId, mentionSegment.record.type, mentionSegment.name, mentionSegment.record.Id));
					}
				}
				if(!responseWrap.isEmpty()){
					res.statusCode = 200;
					return responseWrap;  
				} else {
					res.statusCode = 204;
					responseWrap.add(new ResponseWrapper('', '', '', '', ''));
					return responseWrap;						
				}
			} catch(Exception ex){
				res.statusCode = 500; 
				responseWrap.add(new ResponseWrapper('', '', '', '', ''));
				return responseWrap;				  
			}
		} else {
			res.statusCode = 400;
			responseWrap.add(new ResponseWrapper('', '', '', '', ''));
			return responseWrap;			
		}
	}
}