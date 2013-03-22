/*
@Name : showRouteOnMapCont
@Author : customersuccess@cloud62.com
@Date : 2/10/2013
@Description : Display route info on page.
*/
public class showRouteOnMapCont {
	//variable
	public Route__c route{get;set;}
	
	/*
	@Name :showRouteOnMapCont
	@Description :Constructor, get the Route record Info.
	*/	
    public showRouteOnMapCont(ApexPages.StandardController controller) {
		this.route = (Route__c) controller.getRecord();
    }
    
    /*
	@Name :redirect
	@Description :Redirect to the map page.
	*/	
    public PageReference redirect(){
        return new PageReference('/apex/FindRoute?id='+route.Id);
    }

}