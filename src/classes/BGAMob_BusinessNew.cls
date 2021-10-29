public class BGAMob_BusinessNew
{
    public List<RssFeed> xml{get;set;}
    public static String url{get; set;}
    public String descrp{get; set;}
    public static XMLDom dom;
    public static Boolean testfalg=true;
    public BGAMob_BusinessNew()
    {
        url='https://aerospace.honeywell.com/news/business-aviation/rss';     // let's say this is url for rss feed 
        
        xml = getXmlContent(10,null); 
    }
    public static List<RssFeed> getXmlContent(Integer count,String strguid )
    {
        String body='';
        List<RssFeed> xmlnew = new List<RssFeed>();
        if(testfalg){   
            HttpRequest req=new HttpRequest();
            req.setEndpoint('https://aerospace.honeywell.com/news/business-aviation/rss');
            req.setMethod('GET');
            req.setHeader('Content-Type', 'text/plain');
            req.setCompressed(true);
            HttpResponse res=null;
            Http h=new Http();
            res=h.send(req);
            if(res.getBody()!=null)
            {
                body=res.getBody();
                System.debug('body------>'+body);
            }
            else
            return xmlnew ;
            System.debug('body------>'+body);
            dom=new XMLDom(body);
        }else
        {
            return null;
        }
        Integer intCnt = 0;
        for( xmldom.element e: dom.getElementsByTagName('item')) 
        {
            if(intCnt <count && count != null)
            {
                RssFeed rf=new RssFeed();
                rf.title =e.getValue('title');
                System.debug('Title'+rf.title);
                rf.description=e.getValue('description');
                System.debug('description'+rf.description);
                rf.link=e.getValue('link');
                System.debug('link'+rf.link);
                rf.guid = e.getValue('guid');
                System.debug('guid '+rf.guid);
                rf.pubdate=e.getValue('pubdate');
                System.debug('pubdate'+rf.pubdate);
                String strdate = e.getValue('pubdate');
                system.debug('venat check222--->'+e.getValue('enclosure'));
                system.debug('venat check333--->'+e.getElementsByTagName('enclosure'));                              
                if(e.getValue('enclosure') != null && e.getElementsByTagName('enclosure') != null )
                {
                rf.enclosureurl = e.getElementByTagName('enclosure').getAttribute('url');
                }
                if(strdate!=null && strdate.indexOf(':') > 0)
                {
                System.debug('pubdate new-->'+strdate.substring(0,strdate.indexof(':')-2));
                rf.stdpubdate = strdate.substring(0,strdate.indexof(':')-2);
                }
                String strdesc = e.getValue('description');
                if(strdesc.indexof('\n') > 0)
                {
                System.debug('strdesc new description-->'+strdesc);
                rf.shrtdesc = strdesc.substring(0,strdesc.indexof('\n'));
                }
                xmlnew.add(rf);
                intCnt = intCnt +1;
            }
            else if(count == 0)
            {
                RssFeed rf=new RssFeed();
                rf.title =e.getValue('title');
                System.debug('Title'+rf.title);
                rf.description=e.getValue('description');
                System.debug('description'+rf.description);
                rf.link=e.getValue('link');
                System.debug('link'+rf.link);
                rf.guid = e.getValue('guid');
                System.debug('guid '+rf.guid);
                rf.pubdate=e.getValue('pubdate');
                String strdate = e.getValue('pubdate');
                if(strdate!=null && strdate.indexOf(':') > 0)
                {
                    System.debug('pubdate new-->'+strdate.substring(0,strdate.indexof(':')-2));
                    rf.stdpubdate = strdate.substring(0,strdate.indexof(':')-2);
                }   
                    rf.enclosureurl = e.getElementByTagName('enclosure').getAttribute('url');
                if (strguid == rf.guid)
                {
                    xmlnew.add(rf);
                }
                    intCnt = intCnt +1;
            }
            else if(count == null)
            {
                RssFeed rf=new RssFeed();
                rf.title =e.getValue('title');
                System.debug('Title New-->'+rf.title);
                rf.description=e.getValue('description');
                System.debug('description'+rf.description);
                rf.link=e.getValue('link');
                System.debug('link'+rf.link);
                rf.guid = e.getValue('guid');
                System.debug('guid '+rf.guid);
                rf.pubdate=e.getValue('pubdate');
                System.debug('pubdate'+rf.pubdate);
                String strdate = e.getValue('pubdate');
                rf.enclosureurl = e.getElementByTagName('enclosure').getAttribute('url');
                system.debug('venkat555--->'+rf.enclosureurl);
                if(strdate!=null && strdate.indexOf(':') > 0)
                {
                    System.debug('pubdate new-->'+strdate.substring(0,strdate.indexof(':')-2));
                    rf.stdpubdate = strdate.substring(0,strdate.indexof(':')-2);
                }
                String strdesc = e.getValue('description');
                if(strdesc.indexof('\n') > 0)
                {
                    System.debug('strdesc new description123-->'+strdesc);
                    rf.shrtdesc = strdesc.substring(0,strdesc.indexof('\n'));
                }
                   xmlnew.add(rf);
                    intCnt = intCnt +1;
            } 
        }  
        return xmlnew ;
    }
    public class RssFeed
    {
        public String title {get; set;}
        public String link{get;set;}
        public String description{get; set;}
        public String pubdate{get; set;}
        public String guid{get; set;}
        public String shrtdesc{get; set;}
        public String stdpubdate{get; set;}
        public string enclosureurl{get;set;}
        public void RssFeed(){}
    }
    @RemoteAction
    Static public RssFeed getdescription(String strguid)
    {
        List<RSSFeed> xmlfeed = new List<RSSFeed>();
        System.debug('Hiiiiiii'+strguid);
        xmlfeed = getXmlContent(0,strguid);
        System.debug('Hiiiiiii'+xmlfeed);
        RssFeed rf=new RssFeed();
        rf = xmlfeed.get(0);
        String strdata = rf.description;
        System.debug('strdata '+strdata);
        return rf ;
    }
    @RemoteAction
    Static public List<RssFeed> AddMore()
    {
        List<RSSFeed> xmlfeed = new List<RSSFeed>();
        List<RSSFeed> xmlfeednew = new List<RSSFeed>();
        xmlfeed  = getXmlContent(null,null);
        return xmlfeed ;
    }
    public void readall()
    {
        xml = getXmlContent(15,null);
    }
}