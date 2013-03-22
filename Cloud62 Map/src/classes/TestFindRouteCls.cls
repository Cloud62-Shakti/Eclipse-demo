/*
@Name : TestFindRouteCls
@Author : customersuccess@cloud62.com
@Date : 02/20/2013
@Description : Test FindRouteCls class functionality.
*/
@isTest
private class TestFindRouteCls {

	/*
    @Name :testFindRouteCls1
    @Description : Test FindRouteCls class functionality.
    */
    static testMethod void testFindRouteCls1() {
        Account a = getAccount();
        Contact c = getContact();
        Lead l = getLead();
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',a.Id);
        FindRouteCls fr = new FindRouteCls();
        fr.isAccount = true;
        fr.isContact = true;
        fr.isLead = true;
        fr.findNearBy();
        fr.newSearch();
        fr.getkmOrMile();
        Test.stopTest();
    }
    
    /*
    @Name :testFindRouteCls2
    @Description : Test FindRouteCls class functionality.
    */
    static testMethod void testFindRouteCls2() {
        Account a = getAccount();
        Contact c = getContact();
        Lead l = getLead();
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',c.Id);
        FindRouteCls fr = new FindRouteCls();
        fr.isAccount = true;
        fr.isContact = true;
        fr.isLead = true;
        fr.findNearBy();
        fr.newSearch();
        fr.getkmOrMile();
        Test.stopTest();
    }
    
    /*
    @Name :testFindRouteCls3
    @Description : Test FindRouteCls class functionality.
    */
    static testMethod void testFindRouteCls3() {
        Account a = getAccount();
        Contact c = getContact();
        Lead l = getLead();
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',l.Id);
        FindRouteCls fr = new FindRouteCls();
        fr.distance = 0;
        fr.isAccount = true;
        fr.isContact = true;
        fr.isLead = true;
        fr.findNearBy();
        fr.newSearch();
        fr.getkmOrMile();
        fr.updateLongLat();
        Test.stopTest();
    }
    
    /*
    @Name :testFindRouteCls4
    @Description : Test FindRouteCls class functionality.
    */
    static testMethod void testFindRouteCls4() {
        Account a = getAccount();
        Contact c = getContact();
        Lead l = getLead();
        Route__c r = getRoute(a.Id,c.Id,l.Id);
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',r.Id);
        FindRouteCls fr = new FindRouteCls();
        fr.newSearch();
        fr.getkmOrMile();
        Test.stopTest();
    }
    
    /*
    @Name :testFindRouteCls5
    @Description : Test FindRouteCls class functionality.
    */
    static testMethod void testFindRouteCls5() {
        Account a = getAccount();
        Contact c = getContact();
        Lead l = getLead();
        Route__c r = getRoute(a.Id,c.Id,l.Id);
        r.Main_Location_Id__c = c.Id;
        update r;
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',r.Id);
        FindRouteCls fr = new FindRouteCls();
        fr.newSearch();
        fr.getkmOrMile();
        Test.stopTest();
    }
    
    /*
    @Name :testFindRouteCls6
    @Description : Test FindRouteCls class functionality.
    */
    static testMethod void testFindRouteCls6() {
        Account a = getAccount();
        Contact c = getContact();
        Lead l = getLead();
        Route__c r = getRoute(a.Id,c.Id,l.Id);
        r.Main_Location_Id__c = l.Id;
        update r;
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',r.Id);
        FindRouteCls fr = new FindRouteCls();
        fr.newSearch();
        fr.getkmOrMile();
        Test.stopTest();
    }
    
	/*
    @Name :getAccount
    @Description : prepare the test data for Account record.
    */
    private static Account getAccount(){
        Account acc = new Account(Name = 'Grand Hotels',BillingCity = 'San Francisco', BillingCountry = 'USA', Location__Latitude__s = 37.792727, Type='Customer - Direct',
                        Location__Longitude__s = -122.404382,BillingState = 'CA', BillingStreet = '555 California Street,Suite 4700', BillingPostalCode = '94104');
        insert acc;
        return acc;
    }
    
    /*
    @Name :getContact
    @Description : prepare the test data for Contact record.
    */
    private static Contact getContact(){
        Contact con = new Contact(LastName = 'Green', FirstName='Avi',MailingCity = 'San Francisco', MailingCountry = 'USA', Location__Latitude__s = 37.764878,
                        Location__Longitude__s = -122.432128,MailingState = 'CA', MailingStreet = '2261 Market St', MailingPostalCode = '94114');
        insert con;
        return con;
    }
    
    /*
    @Name :getLead
    @Description : prepare the test data for Lead record.
    */
    private static Lead getLead(){
        Lead led = new Lead(LastName = 'Boxer',FirstName = 'Bertha', City = 'San Francisco', Country = 'USA', State = 'CA', Location__Latitude__s = 37.734050,
                        Status='Working - Contacted',Location__Longitude__s = -122.488837,Street = '1543 Sloat Blvd', PostalCode = '94132', Company = 'ABC Ltd.');
        insert led;
        return led;
    }
    
    /*
    @Name :getRoute
    @Description : prepare the test data for Route__c record.
    */
    private static Route__c getRoute(Id a,Id c,Id l){
        String rPath = a+','+c+','+l;
        Route__c route = new Route__c(Name = 'Test Route',Distance__c = 10,Show_Accounts__c = true,Show_Contacts__c = true,Account_Type__c='Customer - Direct',
                                      Lead_Status__c='Working - Contacted',Show_Leads__c = true,Main_Location_Id__c = a,Path__c = rPath,KmOrMiles__c = 'Miles');
        insert route;
        return route;
    }
    
}