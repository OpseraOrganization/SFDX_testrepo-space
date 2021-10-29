@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    
     global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://aerospace.honeywell.com/news/business-aviation/rss', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
 res.setBody('<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/"><channel><title>Business Aviation | Honeywell Aerospace</title><description>Business Aviation Market</description><link>http://aerospace.honeywell.com/news/business-aviation/rss</link><lastBuildDate>Mon, 12 May 2014 09:38:19 +0000</lastBuildDate><generator>FeedCreator 1.7.3</generator><item><title>High-Quality APU Repair Solution Reduces Costs without Compromising Standards</title><link>http://aerospace.honeywell.com/news/high-quality-apu-repair-solution-reduces-costs-without-compromising-standards</link><description>&lt;em&gt;Aircraft operators are always seeking great deals on essential repairs and maintenance without having to compromise on quality, longevity and service &amp;ndash; Piedmont Aviation is no exception.&lt;/em&gt;&amp;nbsp;&lt;p&gt;As an authorized Honeywell auxiliary power unit (APU) repair center &amp;ndash; and a long-standing Honeywell channel partner &amp;ndash; Piedmont Aviation has access to Honeywell&amp;rsquo;s extensive inventory of new, surplus and reconditioned equipment. &amp;nbsp;All come with warranties, FAA documentation and airworthiness approval tags.&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;Honeywell&amp;rsquo;s market-leading APUs deliver highly reliable electrical and pneumatic power solutions for a variety of aircraft operations, including main engine starting, cabin cooling and electrical power generation.&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;img alt=&quot;&quot; src=&quot;http://cdn2.content.compendiumblog.com/uploads/user/1426dd69-f9a2-42a2-9845-c74cc946e1ed/b201d4da-f942-4be7-b3e4-182ee6a851cb/Image/88d118eca09e65cbf7065bec9cffce94/36_150_w640.jpeg&quot; style=&quot;width: 300px; height: 204px; float: right;&quot; /&gt;&lt;/p&gt;&lt;div&gt;&lt;p&gt;Piedmont has capabilities on a wide variety of &lt;a href=&quot;http://aerospace.honeywell.com/products/auxiliary-power-units&quot;&gt;APUs&lt;/a&gt; for commercial aircraft including Boeing&amp;nbsp;&lt;span style=&quot;line-height: 1.6;&quot;&gt;and Airbus,&lt;/span&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;&amp;nbsp;business jets, as well as military and ground power systems.&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;strong&gt;A Partnership That Works&lt;/strong&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;As a result of Piedmont&amp;rsquo;s relationship with Honeywell, Piedmont can source Honeywell components at preferential prices, enabling the company to maintain highly competitive price points for its customers.&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;Great value and great services are always in demand, but as we continue to recover from the economic downturn, the market for refurbished and reconditioned components has significantly grown.&amp;nbsp;&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;However, customers still demand the same quality, value and reliability from aftermarket spares as they do from new ones. It&amp;rsquo;s a marketplace demand that together, Honeywell and Piedmont, have successfully met.&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;How did we do it? &amp;nbsp;Read the brief &lt;/span&gt;&lt;a href=&quot;https://app.compendium.com/api/post_attachments/de7326ea-ede6-4ba7-8a19-9e8fa8bec927/view&quot;&gt;Honeywell Aerospace Trading and Piedmont Customer Success Story&lt;/a&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;.&lt;/span&gt;&lt;/p&gt;&lt;p&gt;Featured above is one of Honeywell&amp;#39;s APUs. &amp;nbsp;&amp;nbsp;&lt;/p&gt;&lt;/div&gt;</description><category>Aerospace</category><category>Air Transport</category><category>Business Aviation</category><pubDate>Wed, 07 May 2014 19:47:00 +0000</pubDate><guid>http://aerospace.honeywell.com/news/high-quality-apu-repair-solution-reduces-costs-without-compromising-standards</guid><enclosure url="http://cdn2.content.compendiumblog.com/uploads/user/1426dd69-f9a2-42a2-9845-c74cc946e1ed/b201d4da-f942-4be7-b3e4-182ee6a851cb/Image/11c0b4428ac4c1e63e7646efb4467f3a/1500x490_l500_w1024.jpeg" length="0" type="image/jpeg" /><dc:creator>Robin Dayhoff</dc:creator></item> </channel></rss>');           
 res.setStatusCode(200);        res.setStatusCode(200);
        return res;
    }
    global List<RssFeed> xmldata(HTTPRequest req,String strguid,Integer count) {
    XMLDom dom;
    List<RssFeed> xmlnew = new List<RssFeed>();
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('http://aerospace.honeywell.com/news/business-aviation/rss', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
 res.setBody('<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/"><channel><title>Business Aviation | Honeywell Aerospace</title><description>Business Aviation Market</description><link>http://aerospace.honeywell.com/news/business-aviation/rss</link><lastBuildDate>Mon, 12 May 2014 09:38:19 +0000</lastBuildDate><generator>FeedCreator 1.7.3</generator><item><title>High-Quality APU Repair Solution Reduces Costs without Compromising Standards</title><link>http://aerospace.honeywell.com/news/high-quality-apu-repair-solution-reduces-costs-without-compromising-standards</link><description>&lt;em&gt;Aircraft operators are always seeking great deals on essential repairs and maintenance without having to compromise on quality, longevity and service &amp;ndash; Piedmont Aviation is no exception.&lt;/em&gt;&amp;nbsp;&lt;p&gt;As an authorized Honeywell auxiliary power unit (APU) repair center &amp;ndash; and a long-standing Honeywell channel partner &amp;ndash; Piedmont Aviation has access to Honeywell&amp;rsquo;s extensive inventory of new, surplus and reconditioned equipment. &amp;nbsp;All come with warranties, FAA documentation and airworthiness approval tags.&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;Honeywell&amp;rsquo;s market-leading APUs deliver highly reliable electrical and pneumatic power solutions for a variety of aircraft operations, including main engine starting, cabin cooling and electrical power generation.&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;img alt=&quot;&quot; src=&quot;http://cdn2.content.compendiumblog.com/uploads/user/1426dd69-f9a2-42a2-9845-c74cc946e1ed/b201d4da-f942-4be7-b3e4-182ee6a851cb/Image/88d118eca09e65cbf7065bec9cffce94/36_150_w640.jpeg&quot; style=&quot;width: 300px; height: 204px; float: right;&quot; /&gt;&lt;/p&gt;&lt;div&gt;&lt;p&gt;Piedmont has capabilities on a wide variety of &lt;a href=&quot;http://aerospace.honeywell.com/products/auxiliary-power-units&quot;&gt;APUs&lt;/a&gt; for commercial aircraft including Boeing&amp;nbsp;&lt;span style=&quot;line-height: 1.6;&quot;&gt;and Airbus,&lt;/span&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;&amp;nbsp;business jets, as well as military and ground power systems.&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;strong&gt;A Partnership That Works&lt;/strong&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;As a result of Piedmont&amp;rsquo;s relationship with Honeywell, Piedmont can source Honeywell components at preferential prices, enabling the company to maintain highly competitive price points for its customers.&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;Great value and great services are always in demand, but as we continue to recover from the economic downturn, the market for refurbished and reconditioned components has significantly grown.&amp;nbsp;&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;However, customers still demand the same quality, value and reliability from aftermarket spares as they do from new ones. It&amp;rsquo;s a marketplace demand that together, Honeywell and Piedmont, have successfully met.&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;How did we do it? &amp;nbsp;Read the brief &lt;/span&gt;&lt;a href=&quot;https://app.compendium.com/api/post_attachments/de7326ea-ede6-4ba7-8a19-9e8fa8bec927/view&quot;&gt;Honeywell Aerospace Trading and Piedmont Customer Success Story&lt;/a&gt;&lt;span style=&quot;line-height: 1.6;&quot;&gt;.&lt;/span&gt;&lt;/p&gt;&lt;p&gt;Featured above is one of Honeywell&amp;#39;s APUs. &amp;nbsp;&amp;nbsp;&lt;/p&gt;&lt;/div&gt;</description><category>Aerospace</category><category>Air Transport</category><category>Business Aviation</category><pubDate>Wed, 07 May 2014 19:47:00 +0000</pubDate><guid>http://aerospace.honeywell.com/news/high-quality-apu-repair-solution-reduces-costs-without-compromising-standards</guid><enclosure url="http://cdn2.content.compendiumblog.com/uploads/user/1426dd69-f9a2-42a2-9845-c74cc946e1ed/b201d4da-f942-4be7-b3e4-182ee6a851cb/Image/11c0b4428ac4c1e63e7646efb4467f3a/1500x490_l500_w1024.jpeg" length="0" type="image/jpeg" /><dc:creator>Robin Dayhoff</dc:creator></item> </channel></rss>');           
 res.setStatusCode(200);
       dom=new XMLDom(res.getBody());
        Integer intCnt = 0;
for( xmldom.element e: dom.getElementsByTagName('item')) 
        {
           if(intCnt <count)
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
            System.debug('pubdate'+rf.pubdate);
            if (strguid == rf.guid)
            {
            xmlnew.add(rf);
            }
            intCnt = intCnt +1;
            }
            
        }   
        return xmlnew ;
    }
    
   global class RssFeed
{
String title {get; set;}
String link{get;set;}
String description{get; set;}
String pubdate{get; set;}
String guid{get; set;}
    void RssFeed(){}
}
    
}