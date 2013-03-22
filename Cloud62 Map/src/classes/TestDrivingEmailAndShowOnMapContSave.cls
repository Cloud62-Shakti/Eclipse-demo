/*
@Name : TestDrivingEmailAndShowOnMapContSave
@Author : customersuccess@cloud62.com
@Date : 02/20/2013
@Description : Test drivingInstructionsCont,emailRouteCont,LocationCallouts,SaveRouteCls,
                and showRouteOnMapCont classes functionality.
*/
@isTest
private class TestDrivingEmailAndShowOnMapContSave{

    /*
    @Name :testDrivingInstructionsContandEmailRouteCont
    @Description : Test drivingInstructionsCont and emailRouteCont classes functionality.
    */
    static testMethod void testDrivingInstructionsContandEmailRouteCont() {
        Account a = getAccount();
        Contact c = getContact();
        Lead l = getLead();
        String recordID = a.Id+','+c.Id+','+l.Id;
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('Ids',recordID);
        drivingInstructionsCont di = new drivingInstructionsCont();
        emailRouteCont er = new emailRouteCont();
        er.email = 'test@cloud62.com';
        er.send();
        Test.stopTest();
    }
    
    /*
    @Name :testSaveRouteCls
    @Description : Test SaveRouteCls class functionality.
    */
    static testMethod void testSaveRouteCls() {
        Account a = getAccount();
        Contact c = getContact();
        Lead l = getLead();
        Route__c r = getRoute(a.Id,c.Id,l.Id);
        String rID = a.Id+','+c.Id+','+l.Id;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(r);
        ApexPages.CurrentPage().getParameters().put('id',r.Id);
        SaveRouteCls sr = new SaveRouteCls(sc);
        sr.getUpdateOrInsert();
        sr.path = rID;
        sr.distance = '10';
        sr.kmOrMiles = 'KM';
        sr.mainAddressRecordId = c.Id;
        sr.showAccounts = true;
        sr.showContacts = true;
        sr.showLeads = false;
        sr.accountType = null;
        sr.leadStatus = null;
        sr.UpdateRoute = 'New Route';
        sr.route.Name = 'Test Route';
        sr.route.Date__c = System.today();
        sr.save(); 
        Test.stopTest();
    }
    
    /*
    @Name :testshowRouteOnMapCont
    @Description : Test showRouteOnMapCont class functionality.
    */
    static testMethod void testshowRouteOnMapCont() {
        Account a = getAccount();
        Contact c = getContact();
        Lead l = getLead();
        Route__c r = getRoute(a.Id,c.Id,l.Id);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(r);
        showRouteOnMapCont sr = new showRouteOnMapCont(sc);
        sr.redirect();
        Test.stopTest();
    }
    
    /*
    @Name :testLocationCallouts
    @Description : Test LocationCallouts class functionality.
    */
    static testMethod void testLocationCallouts() {
        Account a = getAccount();
        Contact c = getContact();
        Lead l = getLead();
        Test.startTest();
        LocationCallouts lc = new LocationCallouts();
        LocationCallouts.getLocation(a.Id);
        LocationCallouts.getLocation(c.Id);
        LocationCallouts.getLocation(l.Id);
        Test.stopTest();
    }
    
    /*
    @Name :getAccount
    @Description : prepare the test data for Account record.
    */
    private static Account getAccount(){
        Account acc = new Account(Name = 'Grand Hotels',BillingCity = 'San Francisco', BillingCountry = 'USA', 
                        BillingState = 'CA', BillingStreet = '555 California Street,Suite 4700', BillingPostalCode = '94104');
        insert acc;
        return acc;
    }
    
    /*
    @Name :getContact
    @Description : prepare the test data for Contact record.
    */
    private static Contact getContact(){
        Contact con = new Contact(LastName = 'Green', FirstName='Avi',MailingCity = 'San Francisco', MailingCountry = 'USA', 
                        MailingState = 'CA', MailingStreet = '555 California Street,Suite 4700', MailingPostalCode = '94104');
        insert con;
        return con;
    }
    
    /*
    @Name :getLead
    @Description : prepare the test data for Lead record.
    */
    private static Lead getLead(){
        Lead led = new Lead(LastName = 'Boxer',FirstName = 'Bertha', City = 'San Francisco', Country = 'USA', State = 'CA', 
                                Street = '555 California Street,Suite 4700', PostalCode = '94104', Company = 'ABC Ltd.');
        insert led;
        return led;
    }
    
    /*
    @Name :getRoute
    @Description : prepare the test data for Route__c record.
    */
    private static Route__c getRoute(Id a,Id c,Id l){
        String rPath = a+','+c+','+l;
        Route__c route = new Route__c(Name = 'Test Route',Distance__c = 10,Show_Accounts__c = true,Show_Contacts__c = true,
                                      Show_Leads__c = true,Main_Location_Id__c = a,Path__c = rPath,KmOrMiles__c = 'KM');
        insert route;
        return route;
    }
}