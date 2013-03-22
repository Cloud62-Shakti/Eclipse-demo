/*
@Name : MapItem
@Author : customersuccess@cloud62.com
@Date : 2/15/2013
@Description : Return Address string to Account/Contact/LeadGeoLocationCls classes.
*/
public with sharing class MapItem {
    public String rId {get;set;}
    public String rType {get;set;}
    public String rOwner{get;set;}
    public String rPhone{get;set;}
    public String rStreet{get;set;}
    public String rCity{get;set;}
    public String rState{get;set;}
    public String rPostalCode{get;set;}
    public String rCountry{get;set;}
    public String rAddress{get;set;}
    public String rName{get;set;}
    public String rOwnerId{get;set;}
    public Decimal rLat{get;set;}
    public Decimal rLon{get;set;}
    public String rOne {get;set;}
    public String rIndustry {get;set;}
    public String rOneLabel {get;set;}
    public String rIndustryLabel {get;set;}
    
    /*
	@Name :MapItem
	@Description :Constructor, Call from AccountGeoLocation Cls & Prepare rAddress String,
	*/
    public MapItem(Account a){
        rId = a.Id;
        rType = 'Account';
        rName = getCleanName(a.Name);
        rLat = a.Location__Latitude__s;
        rLon = a.Location__Longitude__s;
        rOwnerId = a.OwnerId;
        setAddress(a.BillingStreet,a.BillingCity,a.BillingState,a.BillingPostalCode,a.BillingCountry); 
        rAddress= String.escapeSingleQuotes(getCleanAddress());  
        rphone = a.phone;
        rOwner = a.Owner.Name;
        rOneLabel='Type';
        if(a.Type == null){ rOne = '-';}
        else{ rOne = a.Type;}
        rOneLabel='Industry';
        if(a.Industry == null){ rIndustry = '-';}
        else{ rIndustry = a.Industry;}
    }
    
    /*
	@Name :MapItem
	@Description :Constructor, Call from ContactGeoLocation Cls & Prepare rAddress String,
	*/
    public MapItem(Contact c){
        rId = c.Id;
        rType = 'Contact';
        rName = getCleanName(c.Name);
        rLat = c.Location__Latitude__s;
        rLon = c.Location__Longitude__s;
        rOwnerId = c.OwnerId;
        setAddress(c.MailingStreet,c.MailingCity,c.MailingState,c.MailingPostalCode,c.MailingCountry); 
        rAddress= String.escapeSingleQuotes(getCleanAddress());  
        rphone = c.phone;
        rOwner = c.Owner.Name;
        rOneLabel='Type';
        if(c.Account.Type == null){ rOne = '-';}
        else{ rOne = c.Account.Type;}
        rOneLabel='Industry';
        if(c.Account.Industry == null){ rIndustry = '-';}
        else{ rIndustry = c.Account.Industry;}
        
    }
    
    /*
	@Name :MapItem
	@Description :Constructor, Call from LeadGeoLocation Cls & Prepare rAddress String,
	*/
    public MapItem(Lead l){
        rId = l.Id;
        rType = 'Lead';
        rName = getCleanName(l.Name);
        rOwnerId = l.OwnerId;
        rLat = l.Location__Latitude__s;
        rLon = l.Location__Longitude__s;
        setAddress(l.street,l.city,l.state,l.PostalCode,l.Country); 
        rphone = l.phone;
        rAddress= String.escapeSingleQuotes(getCleanAddress()); 
        rOwner = l.Owner.Name;
        rOneLabel='Status';
        if(l.Status == null) { rOne = '-';}
        else{ rOne = l.Status;}
        if(l.industry == null){ rIndustry = '-';}
        else{ rIndustry = l.industry;}
    }
    
	private Set<String> badChars = new Set<String>{'&', '(', ')','&', ';', ':', '#',  '@', '"', '!', '@', '~', '-', '$', '%', '^',
   													 '&', '*', '_', '+', '=', '?', '{', '[', ']', '}', '|','\n','\r'};
                                                         
    /*
	@Name :getCleanName
	@Description :Clean record name,
	*/
    public String getCleanName(String n){
        String theName='';
        try{
            theName = String.escapeSingleQuotes(n+'');
            for(String theChar: badChars){
                theName = theName.replace(theChar,'');    
            }
            
            if(theName.length()>20){
                theName=theName.substring(0,20);
            }
        }
        catch(Exception e){ theName='-';}
        return theName; 
        
    }
    
    /*
	@Name :getCleanAddress
	@Description :Clean record Address,
	*/
    public String getCleanAddress(){
        
        //Make one String with Street, City, State, Zip, Country... as long as each of the elements exist.
        String theAddress =rStreet;
        try{
            if(rCity.length()>0){ theAddress+=', '+rCity ;}
        }
        catch(Exception e){ }
        try{
            if(rState.length()>0){ theAddress+=', '+rState ;}
        }
        catch(Exception e){ }
        try{
            if(rPostalCode.length()>0){ theAddress+=', '+ rPostalCode;}
        }
        catch(Exception e){ }
        try{
            if(rCountry.length()>0){ theAddress+=', '+ rCountry;} 
        }
        catch(Exception e){ }
        try{
            theAddress = String.escapeSingleQuotes(theAddress+'');
            for(String theChar: badChars){
                theAddress = theAddress.replace(theChar,'');    
            }
        }
        catch(Exception e){ theAddress='-';}
        return theAddress;      
    }
    
    /*
	@Name :setAddress
	@Description :assign value to variables.
	*/
    private void setAddress(String street,string city, string state, string postalCode, string country){
        if (street == null) {street = '';}
        if (city == null) {city = '';}
        if (state == null) {state = '';}
        if (postalCode == null) {postalCode = '';}
        if (Country== null) {Country = '';}
        rStreet = street;
        rCity = city;
        rState = state;
        rPostalCode = postalCode;
        rCountry = Country; 
    }
}