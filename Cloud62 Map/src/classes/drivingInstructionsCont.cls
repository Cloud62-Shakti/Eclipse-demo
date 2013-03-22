/*
@Name : drivingInstructionsCont
@Author : customersuccess@cloud62.com
@Date : 2/10/2013
@Description : Prepare Route points table.
*/
public class drivingInstructionsCont {
//variables
public String ids{get;set;}
public String addresses{get;set;}
public List<RouteWrapper> routeList{get;set;}
	
	/*
	@Name :drivingInstructionsCont
	@Description :Constructor, Prepare points address table base on record IDs,
	*/
    public drivingInstructionsCont(){
        this.ids = apexPages.currentpage().getParameters().get('Ids');
        system.debug('id>> '+ids);
        routeList = new List<RouteWrapper>();
        
        String[] idsArrary = ids.split(',');
        system.debug('1>>>'+idsArrary);
        Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Name, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode FROM Account Where Id IN : idsArrary]);
        Map<Id, Contact> conMap = new Map<Id, Contact>([SELECT Id, Name, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode FROM Contact Where Id IN : idsArrary]);
        Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, Name, City, Country, State, Street, PostalCode FROM Lead Where Id IN : idsArrary]);
        
        if(idsArrary.size()>0){
        Integer i = 1;
            for(integer counter = 0; counter<idsArrary.size();counter++){
                Account a = accMap.get(idsArrary[counter]);
                Contact c = conMap.get(idsArrary[counter]);
                Lead l = leadMap.get(idsArrary[counter]);
                addresses = '';
                if(a!=null){
                    if(a.BillingStreet != null || a.BillingStreet != ''){
                        addresses = addresses  +a.BillingStreet;
                    }
                    if(a.BillingCity != null || a.BillingCity != ''){
                        addresses = addresses +', ' + a.BillingCity;
                    }
                    if(a.BillingPostalCode  != null || a.BillingPostalCode != ''){
                        addresses =addresses  +', ' + a.BillingPostalCode;
                    }
                    if(a.BillingState != null || a.BillingState != ''){
                        addresses =addresses  +', ' + a.BillingState;
                    }
                    if(a.BillingCountry != null || a.BillingCountry != ''){
                        addresses =addresses  +', ' + a.BillingCountry;
                    }
                    RouteWrapper rw = new RouteWrapper(i,a.Id,a.Name,addresses);
                    routeList.add(rw);
                } else if(c!=null){
                    
                    if(c.MailingStreet != null || c.MailingStreet != ''){
                        addresses = addresses  +c.MailingStreet;
                    }
                    if(c.MailingCity != null || c.MailingCity != ''){
                        addresses = addresses +', ' + c.MailingCity;
                    }
                    if(c.MailingPostalCode  != null || c.MailingPostalCode != ''){
                        addresses =addresses  +', ' + c.MailingPostalCode;
                    }
                    if(c.MailingState != null || c.MailingState != ''){
                        addresses =addresses  +', ' + c.MailingState;
                    }
                    if(c.MailingCountry != null || c.MailingCountry != ''){
                        addresses =addresses  +', ' + c.MailingCountry;
                    }
                    RouteWrapper rw = new RouteWrapper(i,c.Id,c.Name,addresses);
                    routeList.add(rw);
                } else if(l!=null){
                    
                    if(l.Street != null || l.Street != ''){
                        addresses = addresses  +l.Street;
                    }
                    if(l.City != null || l.City != ''){
                        addresses = addresses +', ' + l.City;
                    }
                    if(l.PostalCode  != null || l.PostalCode != ''){
                        addresses =addresses  +', ' + l.PostalCode;
                    }
                    if(l.State != null || l.State != ''){
                        addresses =addresses  +', ' + l.State;
                    }
                    if(l.Country != null || l.Country != ''){
                        addresses =addresses  +', ' + l.Country;
                    }
                    RouteWrapper rw = new RouteWrapper(i,l.Id,l.Name,addresses);
                    routeList.add(rw);
                }
                i++;
            }
        }
    }
    
    /*
	@Name :RouteWrapper
	@Description :Wrapper class for preparing route point table
	*/
    public class RouteWrapper{
    	public Integer sNo{get;set;}
    	public String id{get;set;}
        public String name{get;set;}
        public String address{get;set;}
        
        	/*
			@Name :RouteWrapper
			@Description :Wrapper class constructor.
			*/
        	public RouteWrapper(Integer i,String id,String name,String address){
        		this.sNo = i;
        		this.id = id;
        		this.name = name;
        		this.address = address;
        	}
    }
}