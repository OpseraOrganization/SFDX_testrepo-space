/* 
 * Class Name: NCP_InterfaceLogFromIpaaS_WS_Mock
 * Modified Date: 01/JAN/2021
 * Modified By: HCL Technologies
 * Description: This class is mock class for NCP_InterfaceLogFromIpaaS*.
 */
public class NCP_InterfaceLogFromIpaaS_WS_Mock implements HttpCalloutMock 
{
	Map<String, HttpCalloutMock> requests;
	public NCP_InterfaceLogFromIpaaS_WS_Mock(Map<String, HttpCalloutMock> requests) 
	{
		this.requests = requests;
	}

	public HTTPResponse respond(HTTPRequest req) 
	{
		HttpCalloutMock mock = requests.get(req.getEndpoint());
		return mock.respond(req);
	}
}