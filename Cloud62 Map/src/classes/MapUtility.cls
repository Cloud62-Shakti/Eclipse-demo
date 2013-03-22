/*
@Name : MapUtility
@Author : customersuccess@cloud62.com
@Date : 2/15/2013
@Description : Update Account GeoLocation.
*/
public class MapUtility {
    
    /* 
    @Name :getSingleLeadToPlot
    @Description : I will specifically find leads that NEED TO BE GEOLOCATED Pass in a Lead's Id, get all the fields required.
    				If no Id is passed in (null),return ANY lead should be Geolocated. If I can't find anything - return null; 
    */
	public static Lead getSingleLeadToPlot(String id){
    	Lead l; 
		try{
			if(id != null){
				l = [ Select ID,OwnerId, Mapping_Status__c, Location__Latitude__s, Location__Longitude__s, Phone,Status,Industry, PostalCode, State, Street, City, Country, Name,Owner.Name 
                        from Lead where ID =:id limit 1]; 
            } else{ 
				l = [ Select ID, OwnerId, Mapping_Status__c, Location__Latitude__s, Location__Longitude__s, Phone,Status,Industry, PostalCode, State, Street, City, Country, Name,Owner.Name 
                        from Lead where (Mapping_Status__c != 'Located' and Mapping_Status__c != 'Problem with Address') limit 1 ];
            }
         }
         catch(Exception e){ l = null; }
         return l; 
    }

    /*
    @Name :getSingleContactToPlot
    @Description : I will specifically find Contact that NEED TO BE GEOLOCATED Pass in a Contact's Id, get all the fields required. 
    				If no Id is passed in (null), return ANY lead should be Geolocated. If I can't find anything - return null; 
    */
    public static Contact getSingleContactToPlot(String id){
		Contact c;
		try{
			if(id != null) {
				id = String.escapeSingleQuotes(id);
				c = [Select Title, Phone, OwnerId, Name, Owner.Name, Account.Type, Mapping_Status__c, MailingStreet, MailingState, Account.Industry,
					MailingPostalCode, MailingCountry, MailingCity, Location__Latitude__s, Location__Longitude__s, Id, Email From Contact
                    where ID=:id limit 1 ];
			} else {
				c = [Select Title, Phone, OwnerId, Name, Owner.Name, Account.Type, Mapping_Status__c, MailingStreet, MailingState, Account.Industry,
                     MailingPostalCode, MailingCountry, MailingCity, Location__Latitude__s, Location__Longitude__s, Id, Email From Contact
                     where  (Mapping_Status__c != 'Located' and Mapping_Status__c != 'Problem With Address') limit 1];
            }
         }
         catch(Exception e){ c = null;}
         return c; 
    }

    /*
    @Name :getSingleAccountToPlot
    @Description : I will specifically find Accounts that NEED TO BE GEOLOCATED Pass in a Account's Id, get all the fields required. 
    				If no Id is passed in (null), return ANY lead should be Geolocated.
    */
    public static Account getSingleAccountToPlot(String id){
		Account a; 
		try{
			if(id != null){
				a = [Select  OwnerId, Mapping_Status__c, Id,Name, Location__Latitude__s, Location__Longitude__s, Phone, BillingStreet, BillingCity,
					BillingState, BillingPostalCode,BillingCountry, Type, Industry, Owner.Name from Account where ID = :id limit 1];
            } else {
                a = [Select  OwnerId, Mapping_Status__c, Id, Name, Location__Latitude__s, Location__Longitude__s, Phone, BillingStreet, BillingCity, BillingState, 
                    BillingPostalCode, BillingCountry, Type,Industry, Owner.Name from Account where (Mapping_Status__c != 'Located' and Mapping_Status__c != 'Problem With Address') 
                    limit 1];
            }
         }
         catch(Exception e){ a = null; }
         return a;
    }
    
    /*
    @Name :getAccuracy
    @Description : return GeoLocation Accuracy.
    */
    public static Decimal getAccuracy(){
        Decimal num=6;
        try{
            FindNearby__c FNA = FindNearby__c.getOrgDefaults();
            num = FNA.Accuracy__c;
        }catch(Exception e){return 6;}
        if(num < 1){ num = 1;}
        if(num > 9){num = 9;}
        return num;        
    }
	
	/*
    @Name :getAccuracy
    @Description : This will interpret the results from google, determine what the FNA Status should be.
    */
    public static String DetermineStatus(String code,String Accuracy){
		String status = '';
        //Google found something
        if(code == '200') {
			try{
				//Was it accurate enough? 
                if(Double.valueOf(Accuracy)>= Double.valueOf(getAccuracy()+' ' )){
                    status = 'Located';
                } else {
                    status = 'Problem with Address';
                }
            }
            catch(Exception e){
                status = 'Problem with Address';
                System.debug('Determine Status:' + e+' Accuracy:'+Accuracy);
            }
        }//Bad Google Key
        else if (code == '610'){ 
            status = 'Bad Google Maps Key';
        }//Just try some other time
        else if (code == '620' || code =='500'){ 
            status = 'Google Exhausted';
        }//Anything else... probably should try this one again later, or direct attention to address.
        else{
			status= 'Problem with Address';
        }
        return status;
    }
}