/*
@Name : AccountGeoLocationCls
@Author : customersuccess@cloud62.com
@Date : 2/15/2013
@Description : Update Account GeoLocation.
*/
public class AccountGeoLocationCls{
    //variables
    public String Address; 
    public String con;
    public Account l; 
    public Boolean problem=false; 
    public Account getl(){return l;}
    
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
        Boolean doIDoThis = false; 
        try{
            
            FindNearby__c FNA = FindNearby__c.getOrgDefaults();
            doIDoThis = FNA.Accounts__c;
        }catch(Exception e){doIDoThis = false;}
        
        if(!doIDoThis){
            return  Page.ContactGeoLocation;
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
        String Address = '-';
        l = new Account();
        //-----------------
         
        String id = ApexPages.currentPage().getParameters().get('id');
        l = MapUtility.getSingleAccountToPlot(id);
        
        problem = false; // Just got a new address, no problems yet.
        if(l != null ){
            setContinue(true);
            MapItem a = new MapItem(l);
            Address = a.rAddress;   
        }
        return Address;
    }
    
    /*
	@Name :result
	@Description : Update Latitude, Longitude and return to ContactGeoLocationPrep page.
	*/
    public PageReference result() {
        //Get the Status and the Accuracy of the result
        String code = Apexpages.currentPage().getParameters().get('Stat');
        String Accuracy = Apexpages.currentPage().getParameters().get('Acc');
        
        //If there is a Lead to map...
        if(l !=null)
        {
            Account a = new Account(id=l.Id);
            //Clean up the message
            a.Mapping_Status__c = MapUtility.DetermineStatus(code,Accuracy);        
        
            //Determin what to do.  
            if(a.Mapping_Status__c == 'Located'){
            	try{
                    a.Location__Latitude__s = Double.valueOf(Apexpages.currentPage().getParameters().get('Lat'));
                    a.Location__Longitude__s = Double.valueOf(Apexpages.currentPage().getParameters().get('Lon'));
                }
                catch(Exception e){
                    a.Mapping_Status__c = 'Problem with Address';
                }
            }
            if(a.Mapping_Status__c == 'Bad Google Maps Key'){
				return Page.Google_Key_Error;
            }
            if(a.Mapping_Status__c == 'Google Exhausted'){
                return Page.TooMany_Error;
            }
            //If there was a problem with the Address
            if(a.Mapping_Status__c =='Problem with Address'){
                problem = true; 
            }
            
            update a; 
            if(ApexPages.currentPage().getParameters().get('id') != null){
            	return done();
            }
            return null;
        }
        return done();
    }
    
    /*
	@Name :getLName
	@Description : get Account name.
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
	@Description : Redirect to ContactGeoLocationPrep page.
	*/
    public PageReference done(){ 
        String id = ApexPages.currentPage().getParameters().get('id'); 
        
        if(id != null){
            //If there was a problem with the Address
            if(problem){
            	return Page.Address_Problem_Error;
            }
            PageReference p = new PageReference('/apex/FindRoute?id='+id);
            return p;
        } else {
            return Page.ContactGeoLocationPrep;
        }
    }
    
//*********************************************************************************
    private static testMethod void TestAccountGeoLocationCls() {
        AccountGeoLocationCls trol = new AccountGeoLocationCls();
        
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
        Account tL = new Account();
        tL.Name = 'Iman';
        tL.ShippingStreet = 'a';
        tL.ShippingCity = 'a';
        tL.ShippingState = 'Ca';
        tL.ShippingPostalCode = '94105';
        tL.ShippingCountry = 'USA';
        
        insert tL; 
        
        trol.l = tL; 
        trol.getAddress();
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
        trol.getGKey();
      
        trol.init();
        }
        catch(Exception e){}
     }
     
     private static testMethod void TestAccountGeoLocationCls1() {
        Account tL = new Account();
        tL.Name = 'Iman';
        tL.ShippingStreet = 'a';
        tL.ShippingCity = 'a';
        tL.ShippingState = 'Ca';
        tL.ShippingPostalCode = '94105';
        tL.ShippingCountry = 'USA';
        insert tL;
        
        AccountGeoLocationCls trol = new AccountGeoLocationCls();
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
        trol.getAddress();
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
        trol.getGKey();
      
        trol.init();
        }
        catch(Exception e){}
     }
    
}