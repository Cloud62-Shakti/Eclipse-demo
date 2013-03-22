/*
@Name : SaveRouteCls
@Author : customersuccess@cloud62.com
@Date : 2/10/2013
@Description : Upsert Route Info.
*/
public class SaveRouteCls{
    //variables
    public Boolean okToRender{get;set;}
    public String path{get;set;}
    public String mainAddressRecordId{get;set;}
    public String recordIds{get;set;}
    public String distance{get;set;}
    public String kmOrMiles{get;set;}
    public Boolean showAccounts{get;set;}
    public Boolean showContacts{get;set;}
    public Boolean showLeads{get;set;}
    public String filtersNice{get;set;}
    public String filters{get;set;}
    public String filterId{get;set;}
    public String mainAddress{get;set;}
    public String mainAddressLatitude{get;set;}
    public String mainAddressLongitude{get;set;}
    public String ownAddress{get;set;}
    public String ownAddressLatitude{get;set;}
    public String ownAddressLongitude{get;set;}
    public Boolean isUpdate{get;set;}
    public Boolean createEvent{get;set;}
    public Route__c route{get;set;}
    public String startTime{get;set;}
    public String endTime{get;set;}
    public Boolean routeSaved{get;set;}
    public String routeId{get;set;}
    public String UpdateRoute{get;set;}
    public String accountType{get;set;}
    public String leadStatus{get;set;}
    
    /*
	@Name :SaveRouteCls
	@Description :Constructor, Query route record if route is exist already,
	*/
    public SaveRouteCls(ApexPages.StandardController controller) {
        routeId = apexPages.currentpage().getParameters().get('id');
        system.debug('rIds>'+routeId);
        route = new Route__c();
        if(routeId!='' && routeId!=null){
            route = [Select Id, Name,  Date__c, Distance__c, EndDateTime__c, KmOrMiles__c, Main_Location_Id__c, Path__c, Account_Type__c, 
                        Lead_Status__c, RecordIds__c, Show_Accounts__c, Show_Contacts__c, Show_Leads__c, StartDateTime__c From Route__c 
                        Where Id=:routeId];
                        isUpdate = true;
            UpdateRoute = 'Update Route';
        }
        okToRender = true;            
    }
    
    /*
	@Name :getUpdateOrInsert
	@Description :Create SelectOption List.
	*/
    public List<SelectOption> getUpdateOrInsert() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Update Route','Update Route'));
        options.add(new SelectOption('New Route','New Route'));
        return options;
    }
    
    /*
	@Name :save
	@Description :Upsert route info.
	*/
    public void save(){
/*        
        Integer day = route.Date__c.day();
        Integer month = route.Date__c.month();
        Integer year = route.Date__c.year();
        
        List<String> sTime = new List<String>();
        sTime=startTime.split(':');
        List<String> eTime = new List<String>();
        eTime=endTime.split(':');
        
        DateTime startDateTime=DateTime.newInstance(year, month, day, Integer.valueOf(sTime[0]), Integer.valueOf(sTime[1]), 00);
        DateTime endDateTime=DateTime.newInstance(year, month, day, Integer.valueOf(eTime[0]), Integer.valueOf(eTime[1]), 00);

        if(startDateTime!=null){
            route.StartDateTime__c =startDateTime;
        }
        if(endDateTime!=null){
            route.EndDateTime__c =endDateTime;
        }
*/      
        String routeName = route.Name;
        Date routeDate = route.Date__c;
        if(UpdateRoute == 'New Route'){
            route = new Route__c();
            route.Name = routeName;
            route.Date__c = routeDate;
        }
        route.Path__c =path;
        route.Distance__c = Decimal.ValueOf(distance);
        route.KmOrMiles__c = kmOrMiles;
        route.Main_Location_Id__c = mainAddressRecordId; 
        route.Show_Accounts__c = showAccounts;
        route.Show_Contacts__c = showContacts;
        route.Show_Leads__c = showLeads;  
        route.Account_Type__c = accountType;
        route.Lead_Status__c = leadStatus;
        upsert route;
        routeSaved = true;
    }
    
}