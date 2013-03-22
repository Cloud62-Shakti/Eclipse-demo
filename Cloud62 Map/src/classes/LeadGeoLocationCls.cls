/*
@Name : LeadGeoLocationCls
@Author : customersuccess@cloud62.com
@Date : 2/15/2013
@Description : Update Lead GeoLocation.
*/
public class LeadGeoLocationCls{
    //variables
    public String Address; 
    public String con;
    public Boolean Problem=false; 
    public Lead l; 
    public Lead getL(){return l;}
    
    /*
	@Name :getGKey
	@Description : get Google Key from custom setting.
	*/
    public String getGKey(){ 
        try{
        FindNearby__c settings = FindNearby__c.getInstance();
        return settings.GKey__c;
        }
        catch(Exception e){return ' ';}
        
    }
    
    //Currently setting the continue flag with a Boolean - though the value is a String
    //This is probably not a good idea.
    public void setContinue(Boolean flag){ 
        if(flag){ con ='T';}
        else{ con ='F';}
    }
    public String getContinue(){return con;}
     
    /*
	@Name :init
	@Description : This is the first method to be called. Determines if Accounts are turned off at the Global Level.
			If they are ON continue to "GetAddress()" If they are OFF continue to the CGeoCodePrep page.
    */ 
    public pageReference init(){
        Boolean doIDoThis=false;
        try{    
            FindNearby__c FNA = FindNearby__c.getOrgDefaults();
            doIDoThis = FNA.Leads__c;
        }catch(Exception e){
            doIDoThis = false;
        }
        if(!doIDoThis){
            return  Page.AccountGeoLocation;
        }
            
        getAddress();
        return null;
    }
    
    /*
	@Name :getAddress
	@Description : Gets the address of the next item to map.
	*/
    public String getAddress(){ 
        
        //Reset the values
        //-----------------
        setContinue(false);
        Address = '-';
        l = new Lead();
        //-----------------
        
        String id = ApexPages.currentPage().getParameters().get('id'); 
        
        l = MapUtility.getSingleLeadToPlot(id);
        problem = false; 
        if(l != null ){
            setContinue(true);
            MapItem a = new MapItem(l);
            Address = a.rAddress;   
        }       

        return Address;
    }
    
    /*
	@Name :result
	@Description : Update Latitude, Longitude and return to AccountGeoLocation page.
	*/
    public PageReference result() {
        //Get the Status and the Accuracy of the result
        String code = Apexpages.currentPage().getParameters().get('Stat');
        String Accuracy = Apexpages.currentPage().getParameters().get('Acc');
        
        //If there is a Lead to map...
        if(l !=null)
        {
            //Clean up the message
            l.Mapping_Status__c = MapUtility.DetermineStatus(code,Accuracy);        
        
            //Determin what to do. 
            if(l.Mapping_Status__c == 'Located')
            {
                try{
                    l.Location__Latitude__s = Double.valueOf(Apexpages.currentPage().getParameters().get('Lat'));
                    l.Location__Longitude__s = Double.valueOf(Apexpages.currentPage().getParameters().get('Lon'));
                }
                catch(Exception e){
                    l.Mapping_Status__c = 'Problem with Address';
                }
            }
            if(l.Mapping_Status__c == 'Bad Google Maps Key')
            {
                return Page.Google_Key_Error;
            }
            if(l.Mapping_Status__c == 'Google Exhausted')
            {
                return Page.TooMany_Error;
            }
            
            
            //If there was a problem with the Address
            if(l.Mapping_Status__c =='Problem with Address')
            {
                problem = true; 
            }
            
            update l; 
        
            if(ApexPages.currentPage().getParameters().get('id') != null){
                    return done();
             }
                return null;
        }
        
        return done();
        
    }
    
    /*
	@Name :getLName
	@Description : get Lead name.
	*/
    public String getLName(){
        String name = '-';
        try{
            name = String.escapeSingleQuotes(l.Name);
        }
        catch(Exception e){}
        return name;
    }
    
    /*
	@Name :done
	@Description : Redirect to AccountGeoLocation page.
	*/
    public PageReference done(){ 
        String id = ApexPages.currentPage().getParameters().get('id'); 
        
        if(id != null)
        {
            //If there was a problem with the Address
            if(problem)
            {
                return Page.Address_Problem_Error;
            }
            
            //If Not
            PageReference p = new PageReference('/apex/FindRoute?id='+id);
            return p;
        }
        else{    
            return Page.AccountGeoLocation;
        }
    }
    //*********************************************************************************
    private static testMethod void TestLeadGeoLocationCls() {
        LeadGeoLocationCls trol = new LeadGeoLocationCls();
        
        //Test setContinue
        trol.setContinue(true);
        System.assert(trol.con=='T');       
        trol.setContinue(false);
        System.assert(trol.con=='F');       
        
        
        //Test GetContinue
        System.assert(trol.con == trol.GetContinue());
        
        //Test GetLName
        System.assert(trol.getLName() != null);
        System.assert(trol.done() != null);
        try{
        Lead tL = new Lead();
        tL.FirstName = 'Iman';
        tL.LastName = 'Iman';
        tL.Street = 'a';
        tL.City = 'a';
        tL.State = 'Ca';
        tL.PostalCode = '94105';
        tL.Country = 'USA';
        tL.Company='Company';
        trol.getGkey();
        trol.init();
        insert tL; 
        
        trol.l = tL; 
        
        ApexPages.currentPage().getParameters().put('Stat', '200');
        ApexPages.currentPage().getParameters().put('Acc', '7');
        ApexPages.currentPage().getParameters().put('Lat', '7');
        ApexPages.currentPage().getParameters().put('Lon', '7');
        trol.result();
        
        ApexPages.currentPage().getParameters().put('Stat', '200');
        ApexPages.currentPage().getParameters().put('Acc', '4');
        trol.result();
        ApexPages.currentPage().getParameters().put('Stat', '610');
        ApexPages.currentPage().getParameters().put('Acc', '7');   
        trol.result();
        ApexPages.currentPage().getParameters().put('Stat', '620');
        ApexPages.currentPage().getParameters().put('Acc', '7');
        trol.result();
        ApexPages.currentPage().getParameters().put('Stat', '777');
        ApexPages.currentPage().getParameters().put('Acc', '7');     
        trol.result();
        
        trol.getAddress();
        }
        catch(Exception e){}
     }
     
     private static testMethod void TestLeadGeoLocationCls1() {
        Lead tL = new Lead();
        tL.FirstName = 'Iman';
        tL.LastName = 'Iman';
        tL.Street = 'a';
        tL.City = 'a';
        tL.State = 'Ca';
        tL.PostalCode = '94105';
        tL.Country = 'USA';
        tL.Company='Company';
        //tL.Mapping_Status__c = 'Located'; 
        insert tL; 
        
        LeadGeoLocationCls trol = new LeadGeoLocationCls();
        trol.getGkey();
        trol.init();
        trol.getL();
        
        ApexPages.currentPage().getParameters().put('id', tL.Id);
        trol.getAddress();
        
        //Test setContinue
        trol.setContinue(true);
        System.assert(trol.con=='T');       
        trol.setContinue(false);
        System.assert(trol.con=='F');       
        
        
        //Test GetContinue
        System.assert(trol.con == trol.GetContinue());
        
        //Test GetLName
        System.assert(trol.getLName() != null);
        System.assert(trol.done() != null);
        try{
        	
        trol.l = tL; 
        
        ApexPages.currentPage().getParameters().put('Stat', '200');
        ApexPages.currentPage().getParameters().put('Acc', '7');
        ApexPages.currentPage().getParameters().put('Lat', '7');
        ApexPages.currentPage().getParameters().put('Lon', '7');
        trol.result();
        
        ApexPages.currentPage().getParameters().put('Stat', '200');
        ApexPages.currentPage().getParameters().put('Acc', '4');
        trol.result();
        ApexPages.currentPage().getParameters().put('Stat', '610');
        ApexPages.currentPage().getParameters().put('Acc', '7');   
        trol.result();
        ApexPages.currentPage().getParameters().put('Stat', '620');
        ApexPages.currentPage().getParameters().put('Acc', '7');
        trol.result();
        ApexPages.currentPage().getParameters().put('Stat', '777');
        ApexPages.currentPage().getParameters().put('Acc', '7');     
        trol.result();
        
        trol.getAddress();
        }
        catch(Exception e){}
     }
    
}