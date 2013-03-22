/*
@Name : ContactGeoLocationCls
@Author : customersuccess@cloud62.com
@Date : 2/15/2013
@Description : Update Contact GeoLocation.
*/
public class ContactGeoLocationCls{
    public String Address; 
    public String con;
    public Contact l; 
    public Contact getl(){return l;}
    public Boolean Problem = false; 
    
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
            doIDoThis = FNA.Contacts__c;
        }catch(Exception e){
            doIDoThis = false;
        }
        
        if(!doIDoThis){
           return Page.CompleteGeoCoding;
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
        l = new Contact();
        //-----------------
        String id = ApexPages.currentPage().getParameters().get('id');
        l = MapUtility.getSingleContactToPlot(id) ;
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
	@Description : Update Latitude, Longitude and return to CompleteGeoCoding page.
	*/
    public PageReference result() {
        //Get the Status and the Accuracy of the result
        String code = Apexpages.currentPage().getParameters().get('Stat');
        String Accuracy = Apexpages.currentPage().getParameters().get('Acc');
        
        //If there is a Lead to map...
        if(l !=null)
        {
            Contact a = new Contact(id=l.Id);
            //Clean up the message
            a.Mapping_Status__c = MapUtility.DetermineStatus(code,Accuracy);        
        
            //Determin what to do.  
            if(a.Mapping_Status__c == 'Located')
            {
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
            
            try{
            	update a; 
            }
            catch(Exception e){ }
            
            if(ApexPages.currentPage().getParameters().get('id') != null){
            	return done();
            }
            return null;
        }
        
        return done();
        
    }
    
    /*
	@Name :getLName
	@Description : get Contact Last name.
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
	@Description : return to CompleteGeoCoding page.
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
        } else{
            return Page.CompleteGeoCoding;
        }
    }
    
    /*
	@Name :preTest
	@Description : return to ContactGeoLocation page.
	*/
    public PageReference preTest(){
        PageReference p = Page.ContactGeoLocation;
        p.setRedirect(true);
        return p;
    }
//*********************************************************************************
    private static testMethod void TestContactGeoLocationCls() {
        ContactGeoLocationCls trol = new ContactGeoLocationCls();
        
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
        
        Contact tL = new Contact();
        tL.FirstName = 'Iman';
        tL.LastName = 'B';
        tL.OtherStreet = 'a';
        tL.OtherCity = 'a';
        tL.OtherState = 'Ca';
        tL.OtherPostalCode = '94105';
        tL.OtherCountry = 'USA';
        try{
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
          trol.preTest();
           trol.getGKey();
        trol.init();
        }
        catch(Exception e){}
     }
     
     private static testMethod void TestContactGeoLocationCls1() {
        Contact tL = new Contact();
        tL.FirstName = 'Iman';
        tL.LastName = 'B';
        tL.OtherStreet = 'a';
        tL.OtherCity = 'a';
        tL.OtherState = 'Ca';
        tL.OtherPostalCode = '94105';
        tL.OtherCountry = 'USA';
        insert tL; 
        
        ContactGeoLocationCls trol = new ContactGeoLocationCls();
        trol.getGkey();
        trol.init();
        trol.getL();
        
        ApexPages.currentPage().getParameters().put('id', tL.Id);
        trol.getAddress();
        trol.done();
        
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
	        trol.preTest();
	        trol.getGKey();
	        trol.init();
        }
        catch(Exception e){}
     }
    
}