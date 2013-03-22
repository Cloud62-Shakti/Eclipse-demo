/*
@Name : emailRouteCont
@Author : customersuccess@cloud62.com
@Date : 2/10/2013
@Description : Email Driving Instruction.
*/
public class emailRouteCont {
	//variables
    public Boolean sendToUser { get; set; }
    public String locations { get; set; }
    public String drivingInstructions { get; set; }
    public String totalLengthOfRoute { get; set; }
    public String email { get; set; }
    public Boolean showDrivingInstructions{get;set;}
    public inputHolder__c inputHolder{get;set;}
    public Boolean closeWindow{get;set;}
    public List<String> emailAddress = new List<String>();
    public String ids{get;set;}
    public String addresses{get;set;}
    
    /*
	@Name :emailRouteCont
	@Description :Constructor, Prepare points address String base on record IDs,
	*/
    public emailRouteCont(){
        ids = apexPages.currentpage().getParameters().get('Ids');
        sendToUser=true;
        inputHolder = new inputHolder__c();
        inputHolder.User__c = userInfo.getUserId();
        addresses = '';
        system.debug('ids>>'+ids);
        
        String[] idsArrary = ids.split(',');
        system.debug('idsList>>'+idsArrary);
        
        Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Name, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode FROM Account Where Id IN : idsArrary]);
        Map<Id, Contact> conMap = new Map<Id, Contact>([SELECT Id, Name, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode FROM Contact Where Id IN : idsArrary]);
        Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, Name, City, Country, State, Street, PostalCode FROM Lead Where Id IN : idsArrary]);
        
        if(idsArrary.size()>0){
        Integer i = 1;
            for(integer counter = 0; counter<idsArrary.size();counter++){
                Account a = accMap.get(idsArrary[counter]);
                Contact c = conMap.get(idsArrary[counter]);
                Lead l = leadMap.get(idsArrary[counter]);
                if(a!=null){
	                if(a.Name != null || a.Name != ''){
	                    addresses =addresses +i+'. '+ a.Name +' (';
	                }
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
	                    addresses =addresses  +', ' + a.BillingCountry+')~';
	                }
                } else if(c!=null){
                	if(c.Name != null || c.Name != ''){
	                    addresses =addresses +i+'. '+ c.Name +' (';
	                }
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
	                    addresses =addresses  +', ' + c.MailingCountry+')~';
	                }
                } else if(l!=null){
                	if(l.Name != null || l.Name != ''){
	                    addresses =addresses +i+'. '+ l.Name +' (';
	                }
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
	                    addresses =addresses  +', ' + l.Country+')~';
	                }
                }
                i++;
            }
        }    
        
    }
    
    /*
	@Name :send
	@Description :Email Driving Instruction.
	*/    
    public PageReference send(){
        insert inputHolder;
        
        inputHolder__c ih = [select id, user__c from inputHolder__c where id=:inputHolder.Id];
        User u = [Select id, Email from User where id=:ih.user__c];
        
        List<String> acPointList = addresses.split('~');
        String emailBodyContent = '<html>'+'<h4>'+'<U>'+'Points On The Way'+'</h4>'+'</U>';
        for(String s : acPointList){
            emailBodyContent = emailBodyContent + s + '<br/>'+'<br/>';
        }
        
        if(sendToUser==true){
            emailAddress.add(u.Email);
        }else{
            emailAddress.add(email);
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = emailAddress;
        mail.setToAddresses(toAddresses);
        mail.setSubject('Route Details');
        if(showDrivingInstructions==true){
            mail.setHtmlBody(emailBodyContent+totalLengthOfRoute+'<h4>'+'<U>'+'Driving Instructions'+'</U>'+'</h4>'+drivingInstructions+'</html>');
        }else{
            mail.setHtmlBody(emailBodyContent+totalLengthOfRoute+'</html>');
        }
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        return null;
    }
    
}