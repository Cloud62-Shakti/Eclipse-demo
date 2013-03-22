/*
@Name : FindRouteCls
@Author : customersuccess@cloud62.com
@Date : 2/10/2013
@Description : Find NearBy Google Map Controller.
*/
public class FindRouteCls{
    //String variables
    public String routeRecordId{get;set;}
    public String kmOrMileValue{get;set;}
    public String recordsSearched{get;set;}
    public String routeLatLong1{get;set;}
    public String routeLatLong2{get;set;}
    public String routeLatLong3{get;set;}
    public String routeLatLong4{get;set;}
    public String routeLatLong5{get;set;}
    public String routeLatLong6{get;set;}
    public String routeLatLong7{get;set;}
    public String routeLatLong8{get;set;}
    public String routeLatLong9{get;set;}
    public String routeLatLong10{get;set;}
    public String locId1{get;set;}
    public String locId2{get;set;}
    public String locId3{get;set;}
    public String locId4{get;set;}
    public String locId5{get;set;}
    public String locId6{get;set;}
    public String locId7{get;set;}
    public String locId8{get;set;}
    public String locId9{get;set;}
    public String locId10{get;set;}
    public String recordId{get;set;}
    public String filters{get;set;}
    public String filtersNice{get;set;}
    public String filterId{get;set;}
    public String routeId{get;set;}
    public String recordIds{get;set;}
    public String routeName{get;set;}
    public String clientName{get;set;}
    public String addresses{get;set;}
    public String MainAddressName{get;set;}
    public String MainAddressStreet{get;set;}
    public String MainAddressCity{get;set;}
    public String MainAddressZip{get;set;}
    public String MainAddressCountry{get;set;}
    public String MainAddressState{get;set;}
    public String OwnAddressName{get;set;}
    public String OwnAddressStreet{get;set;}
    public String OwnAddressCity{get;set;}
    public String OwnAddressZip{get;set;}
    public String OwnAddressCountry{get;set;}
    public String OwnAddressState{get;set;}
    public String OwnAddressLatitude{get;set;}
    public String OwnAddressLongitude{get;set;}
    public String OwnAddressUsed{get;set;}
    public String Longitude{get;set;}
    public String Latitude{get;set;}
    public String MainAddressIWExtraInfo{get;set;}
    public String accStr{get;set;}
    public String ledStr{get;set;}
    
    //Boolean variables
    public Boolean isAccount{get;set;}
    public Boolean isContact{get;set;}
    public Boolean isLead{get;set;}
    public Boolean foundAccounts{get;set;}
    public Boolean foundContacts{get;set;}
    public Boolean foundLeads{get;set;}
    public Boolean findOnlyMyRecords{get;set;}
    public Boolean isFindTrue{get;set;}
    public Boolean findNearByDetailsDivShown{get;set;}
    public Boolean isFromRoute{get;set;}
    
    //Integer variable
    public Integer distanceNumDigits{get;set;}
    public Integer distance{get;set;}
    
    //sObjects variable
    public Account acc{get;set;}
    public Contact con{get;set;}
    public Lead led{get;set;}
    public Route__c route{get;set;}
    public Account acct{get;set;}
    public Lead leadFtr{get;set;}
    
    //List variable
    public List<Account> accounts{get;set;}
    public List<Contact> contacts{get;set;}
    public List<Lead> leads{get;set;}
    public List<RouteWrapper> accountTable{get; set;}
    public List<RouteWrapper> contactTable{get;set;}
    public List<RouteWrapper> leadTable{get;set;}
    public List<RouteWrapper> mainAddressTable {get;set;}
    public List<RouteWrapper> routeDisplayList {get;set;}
    
    /*
	@Name :FindRouteCls
	@Description :Constructor, Prepare main address table base on record ID,
	*/    
    public FindRouteCls() {
    	//assign memory to the variables;
	    acct = new Account();
	    leadFtr = new Lead();
	    leadFtr.Status = '';
	    mainAddressTable = new List<RouteWrapper>();
        routeDisplayList = new List<RouteWrapper>();
        accounts = new List<Account>();
        contacts = new List<Contact>();
        leads = new List<Lead>();
        
        distance = 10;
        findNearByDetailsDivShown=false;
        distanceNumDigits = 3; 
        kmOrMileValue = 'KM';
        this.routeRecordId = apexPages.currentpage().getParameters().get('id');
        String rRecordID = routeRecordId.substring(0,3);
        
        //user comes from Accounts.
        if(rRecordID.startsWith('001')){
            this.acc = [Select Id, Name, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode, Location__Latitude__s, Location__Longitude__s From Account Where Id=:routeRecordId];
            recordId=acc.Id;
            RouteWrapper rw = new RouteWrapper(null,acc.Name,acc.Id,String.valueOf(acc.Location__Latitude__s),String.valueOf(acc.Location__Longitude__s),acc.BillingStreet,acc.BillingPostalCode,acc.BillingCity,acc.BillingState,acc.BillingCountry,null);
            mainAddressTable.add(rw);
            isAccount = true;
            
        }//user comes from Contacts. 
        else if(rRecordID.startsWith('003')){
            this.con = [Select Id, Name, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode, Location__Latitude__s, Location__Longitude__s From Contact Where Id=:routeRecordId];
            recordId=con.Id;
            RouteWrapper rw = new RouteWrapper(null,con.Name,con.Id,String.valueOf(con.Location__Latitude__s),String.valueOf(con.Location__Longitude__s),con.MailingStreet,con.MailingPostalCode,con.MailingCity,con.MailingState,con.MailingCountry,null);
            mainAddressTable.add(rw);
            isContact = true;
            
        }//user comes from Leads.
        else if(rRecordID.startsWith('00Q')){
            this.led = [Select Id, Name, City, Country, State, Street, PostalCode, Location__Latitude__s, Location__Longitude__s From Lead Where Id=:routeRecordId];
            recordId=led.Id;
            RouteWrapper rw = new RouteWrapper(null,led.Name,led.Id,String.valueOf(led.Location__Latitude__s),String.valueOf(led.Location__Longitude__s),led.Street,led.PostalCode,led.City,led.State,led.Country,null);
            mainAddressTable.add(rw);
            isLead = true;
        
        }//User comes from Routes.
        else {
            routeRedirect();
        }
        
    }
    
    /*
	@Name :routeRedirect
	@Description :When User Comes from Route__c object, Prepare Main Address Table & Route Display Table, and call findNearBy method.
	*/ 
    public void routeRedirect(){
        //Query route record.
        route = [Select r.StartDateTime__c, r.Account_Type__c, r.Lead_Status__c, r.Show_Leads__c, r.Show_Contacts__c, r.Show_Accounts__c, r.Path__c, r.OwnerId, r.Name, r.Main_Location_Id__c,  r.KmOrMiles__c, r.Id, r.EndDateTime__c, r.Distance__c, r.Date__c From Route__c r Where ID =:routeRecordId];
        routeRecordId = route.Main_Location_Id__c;
        String rRcrdID = routeRecordId.substring(0,3);
        routeName = route.Name;
        routeId = route.Id;
        isLead = route.Show_Leads__c;
        isContact = route.Show_Contacts__c;
        isAccount = route.Show_Accounts__c;
        acct.Type = route.Account_Type__c;
        leadFtr.Status = route.Lead_Status__c;
        kmOrMileValue = route.KmOrMiles__c;
        distance = Integer.valueOf(route.Distance__c);
        isFromRoute = true;

		//Prepare main address table if Route main location id is Account ID.        
        if(rRcrdID.startsWith('001')){
            this.acc = [Select Id, Name, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode, Location__Latitude__s, Location__Longitude__s From Account Where Id=:routeRecordId];
            recordId=acc.Id;
            RouteWrapper rw = new RouteWrapper(null,acc.Name,acc.Id,String.valueOf(acc.Location__Latitude__s),String.valueOf(acc.Location__Longitude__s),acc.BillingStreet,acc.BillingPostalCode,acc.BillingCity,acc.BillingState,acc.BillingCountry,null);
            mainAddressTable.add(rw);
            isAccount = true;
            
        }//Prepare main address table if Route main location id is Contact ID.
        else if(rRcrdID.startsWith('003')){
            this.con = [Select Id, Name, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode, Location__Latitude__s, Location__Longitude__s From Contact Where Id=:routeRecordId];
            recordId=con.Id;
            RouteWrapper rw = new RouteWrapper(null,con.Name,con.Id,String.valueOf(con.Location__Latitude__s),String.valueOf(con.Location__Longitude__s),con.MailingStreet,con.MailingPostalCode,con.MailingCity,con.MailingState,con.MailingCountry,null);
            mainAddressTable.add(rw);
            isContact = true;
            
        }//Prepare main address table if Route main location id is Lead ID.
        else if(rRcrdID.startsWith('00Q')){
            this.led = [Select Id, Name, City, Country, State, Street, PostalCode, Location__Latitude__s, Location__Longitude__s From Lead Where Id=:routeRecordId];
            recordId=led.Id;
            RouteWrapper rw = new RouteWrapper(null,led.Name,led.Id,String.valueOf(led.Location__Latitude__s),String.valueOf(led.Location__Longitude__s),led.Street,led.PostalCode,led.City,led.State,led.Country,null);
            mainAddressTable.add(rw);
            isLead = true;
        }
        
        //Prepare Route Detail Table.
        String routePath = route.Path__c;
        String[] idsArrary = routePath.split(',');
        
        Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Name, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode, Location__Latitude__s, Location__Longitude__s From Account Where Id IN : idsArrary]);
        Map<Id, Contact> conMap = new Map<Id, Contact>([Select Id, Name, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode, Location__Latitude__s, Location__Longitude__s From Contact Where Id IN : idsArrary]);
        Map<Id, Lead> leadMap = new Map<Id, Lead>([Select Id, Name, City, Country, State, Street, PostalCode, Location__Latitude__s, Location__Longitude__s From Lead Where Id IN : idsArrary]);
        if(idsArrary.size()>0){
            for(integer counter = 0; counter<idsArrary.size();counter++){
                Account a = accMap.get(idsArrary[counter]);
                Contact c = conMap.get(idsArrary[counter]);
                Lead l = leadMap.get(idsArrary[counter]);
                if(a!=null){
                    RouteWrapper rw = new RouteWrapper(null,a.Name,a.Id,String.valueOf(a.Location__Latitude__s),String.valueOf(a.Location__Longitude__s),a.BillingStreet,a.BillingPostalCode,a.BillingCity,a.BillingState,a.BillingCountry,null);
                        routeDisplayList.add(rw);
                } else if(c!=null){
                    RouteWrapper rw = new RouteWrapper(null,c.Name,c.Id,String.valueOf(c.Location__Latitude__s),String.valueOf(c.Location__Longitude__s),c.MailingStreet,c.MailingPostalCode,c.MailingCity,c.MailingState,c.MailingCountry,null);
                        routeDisplayList.add(rw);
                } else if(l!=null){
                    RouteWrapper rw = new RouteWrapper(null,l.Name,l.Id,String.valueOf(l.Location__Latitude__s),String.valueOf(l.Location__Longitude__s),l.Street,l.PostalCode,l.City,l.State,l.Country,null);
                        routeDisplayList.add(rw);
                }
            }
        }
        //call find near by method.
        findNearBy();
    }
    
    /*
	@Name :findNearBy
	@Description :Prepare Account, Contact and Lead table based on search criteria.
	*/ 
    public pagereference findNearBy(){
        //set distance value 10 if value is null or 0.
        if(distance==0){
            distance=10;
        }
        getRecordsSearched();
        //initialize sObject list.
        accountTable = new List<RouteWrapper>();
        contactTable = new List<RouteWrapper>();
        leadTable = new List<RouteWrapper>();
        
        //String accId = acc.Id;
        isFindTrue = true;
        findNearByDetailsDivShown=true;
        
        String kmOrMi;
        if(kmOrMileValue=='KM'){
            kmOrMi = 'km';
        }else{
            kmOrMi = 'mi';
        }
        
        //Create Account Filter criteria string if user select any on the page.
        if(acct.Type == null || acct.Type == ''){
            accStr = '';
        } else {
            accStr = ' AND Type=\''+acct.Type+'\'';
        }
        //Account List Preparing
        if(isAccount){
            Integer i = 1;
            String q = 'SELECT Id, Name, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode, Location__Latitude__s, Location__Longitude__s FROM Account WHERE DISTANCE(Location__c, GEOLOCATION('+mainAddressTable[0].latitude+','+mainAddressTable[0].longitude+'), \''+kmOrMi+'\') < '+ distance+' AND Id!=\'' + routeRecordId+'\''+accStr;
            if(findOnlyMyRecords==True){
                q = q + ' AND OwnerId =\'' + userInfo.getUserId()+'\'' ; 
            }
            accounts = Database.query(q);
            for(Account a : accounts){
                if(kmOrMileValue=='KM'){
                    RouteWrapper rw = new RouteWrapper(i,a.Name,a.Id,String.valueOf(a.Location__Latitude__s),String.valueOf(a.Location__Longitude__s),a.BillingStreet,a.BillingPostalCode,a.BillingCity,a.BillingState,a.BillingCountry,distance(Decimal.valueOf(mainAddressTable[0].latitude),Decimal.valueOf(mainAddressTable[0].longitude),a.Location__Latitude__s,a.Location__Longitude__s,'K'));
                    accountTable.add(rw);
                }
                if(kmOrMileValue=='Miles'){
                    RouteWrapper rw = new RouteWrapper(i,a.Name,a.Id,String.valueOf(a.Location__Latitude__s),String.valueOf(a.Location__Longitude__s),a.BillingStreet,a.BillingPostalCode,a.BillingCity,a.BillingState,a.BillingCountry,distance(Decimal.valueOf(mainAddressTable[0].latitude),Decimal.valueOf(mainAddressTable[0].longitude),a.Location__Latitude__s,a.Location__Longitude__s,'M'));
                    accountTable.add(rw);
                }
                i++;
            }
            if(accountTable.size()>0){
                foundAccounts = true;
            }
        }
        
        //Contact List Preparing
        if(isContact){
            Integer i = 1;
            String q = 'SELECT Id, Name, MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode, Location__Latitude__s, Location__Longitude__s FROM Contact WHERE DISTANCE(Location__c, GEOLOCATION('+mainAddressTable[0].latitude+','+mainAddressTable[0].longitude+'), \''+kmOrMi+'\') < '+ distance+' AND Id!=\'' + routeRecordId+'\'' ;
            if(findOnlyMyRecords==True){
                q = q + ' AND OwnerId =\'' + userInfo.getUserId()+'\'' ; 
            }
            contacts = Database.query(q);
            for(Contact c : contacts){
                if(kmOrMileValue=='KM'){
                    RouteWrapper rw = new RouteWrapper(i,c.Name,c.Id,String.valueOf(c.Location__Latitude__s),String.valueOf(c.Location__Longitude__s),c.MailingStreet,c.MailingPostalCode,c.MailingCity,c.MailingState,c.MailingCountry,distance(Decimal.valueOf(mainAddressTable[0].latitude),Decimal.valueOf(mainAddressTable[0].longitude),c.Location__Latitude__s,c.Location__Longitude__s,'K'));
                    contactTable.add(rw);
                }
                if(kmOrMileValue=='Miles'){
                    RouteWrapper rw = new RouteWrapper(i,c.Name,c.Id,String.valueOf(c.Location__Latitude__s),String.valueOf(c.Location__Longitude__s),c.MailingStreet,c.MailingPostalCode,c.MailingCity,c.MailingState,c.MailingCountry,distance(Decimal.valueOf(mainAddressTable[0].latitude),Decimal.valueOf(mainAddressTable[0].longitude),c.Location__Latitude__s,c.Location__Longitude__s,'M'));
                    contactTable.add(rw);
                }
                i++;
            }
            if(contactTable.size()>0){
                foundContacts = true;
            }
        }
        
        //Create Lead Filter criteria string if user select any on the page.
        if(leadFtr.Status == null || leadFtr.Status == ''){
            ledStr = '';
        } else {
            ledStr = ' AND Status=\''+leadFtr.Status+'\'';
        }
        //Lead List Preparing
        if(isLead){
            Integer i = 1;
            String q = 'SELECT Id, Name, City, Country, State, Street, PostalCode, Location__Latitude__s, Location__Longitude__s FROM Lead WHERE DISTANCE(Location__c, GEOLOCATION('+mainAddressTable[0].latitude+','+mainAddressTable[0].longitude+'), \''+kmOrMi+'\') < '+ distance+' AND Id!=\'' + routeRecordId+'\''+ledStr;
            if(findOnlyMyRecords==True){
                q = q + ' AND OwnerId =\'' + userInfo.getUserId()+'\'' ; 
            }
            leads = Database.query(q);
            for(Lead l : leads){
                if(kmOrMileValue=='KM'){
                    RouteWrapper rw = new RouteWrapper(i,l.Name,l.Id,String.valueOf(l.Location__Latitude__s),String.valueOf(l.Location__Longitude__s),l.Street,l.PostalCode,l.City,l.State,l.Country,distance(Decimal.valueOf(mainAddressTable[0].latitude),Decimal.valueOf(mainAddressTable[0].longitude),l.Location__Latitude__s,l.Location__Longitude__s,'K'));
                    leadTable.add(rw);
                }
                if(kmOrMileValue=='Miles'){
                    RouteWrapper rw = new RouteWrapper(i,l.Name,l.Id,String.valueOf(l.Location__Latitude__s),String.valueOf(l.Location__Longitude__s),l.Street,l.PostalCode,l.City,l.State,l.Country,distance(Decimal.valueOf(mainAddressTable[0].latitude),Decimal.valueOf(mainAddressTable[0].longitude),l.Location__Latitude__s,l.Location__Longitude__s,'M'));
                    leadTable.add(rw);
                }
                i++;
            }
            if(leadTable.size()>0){
                foundLeads = true;
            }
        }
        return null;
    }
    
    /*
	@Name :getRecordsSearched
	@Description :Create recordSearched String base on search criteria.
	*/ 
    public void getRecordsSearched(){
        recordsSearched = '';
        if(isAccount){
            recordsSearched = 'Accounts';
        }
        if(isContact){
            if(isAccount){
                recordsSearched += ', ';
            }
            recordsSearched += 'Contacts';
        }
        if(isLead){
            if((isAccount && !isContact) || (!isAccount && isContact) || (isAccount && isContact)){
                recordsSearched += ', ';
            }
            recordsSearched += 'Leads';
        }
    }
    
    /*
	@Name :newSearch
	@Description :Clear Account, Contact and Lead list when user click on newSerch button.
	*/
    public pageReference newSearch(){
        acct.Type = '';
        leadFtr.Status = '';
        isFindTrue = False;
        isFromRoute = False;
        routeLatLong1='';
        routeLatLong2='';
        routeLatLong3='';
        routeLatLong4='';
        routeLatLong5='';
        routeLatLong6='';
        routeLatLong7='';
        routeLatLong8='';
        routeLatLong9='';
        routeLatLong10='';
        if(accounts.size()>0){
            accounts.clear();
        }
        if(contacts.size()>0){
            contacts.clear();
        }
        if(leads.size()>0){
            leads.clear();
        }
        if(accountTable.size()>0){
            accountTable.clear();
        }
        if(contactTable.size()>0){
            contactTable.clear();
        }
        if(leadTable.size()>0){
            leadTable.clear();
        }
        if(routeDisplayList.size()>0){
            routeDisplayList.clear();
        }
        
        foundAccounts = false;
        foundContacts = false;
        foundLeads = false;
        findNearByDetailsDivShown = false;
        return null;
    }
    
    /*
	@Name :RouteWrapper
	@Description :Wrapper class for creating Route(Main Record,Account,Contact,Lead) tables.
	*/
    public class RouteWrapper{
        //variable
        public Integer serialNumber{get;set;}
        public String id{get;set;}
        public String name{get;set;}
        public String latitude{get;set;}
        public String longitude{get;set;}
        public String street{get;set;}
        public String postalCode{get;set;}
        public String city{get;set;}
        public String state{get;set;}
        public String Country{get;set;}
        public Decimal distance{get;set;}
        	
        	/*
			@Name :RouteWrapper
			@Description :Constructor,
			*/
            public RouteWrapper(Integer sNo, String name,String ids,String lat,String lng,String stret,String pCode,String cty,String ste,String ctry,Decimal dist){
                this.serialNumber = sNo;
                this.id = ids;
                this.name = name;
                this.latitude = lat;
                this.longitude = lng;
                this.street = stret;
                this.postalCode = pCode;
                this.city = cty;
                this.state = ste;
                this.Country = ctry;
                if(dist!=null){
                    this.distance = dist.setScale(2);
                }else{
                    this.distance = null;
                }
            }
    }
    
    /*
	@Name :getkmOrMile
	@Description :return SelectOption Type List.
	*/
    public List<SelectOption> getkmOrMile() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('KM','KM'));
        options.add(new SelectOption('Miles','Miles'));
        return options;
    }
    
    /*
	@Name :distance
	@Description :Caltulate Distance between main address to other location based on KM or MILES.
	*/
    private Decimal distance(Decimal lat1, Decimal lon1, Decimal lat2, Decimal lon2, String unit) {
        Decimal theta = lon1 - lon2;
        Decimal dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));
        dist = Math.acos(dist);
        dist = rad2deg(dist);
        dist = dist*60*1.1515;
        if (unit == 'K') {
            dist = dist*1.609344;
        } else if (unit == 'N') {
            dist = dist*0.8684;
        }
        return (dist);
    }

    /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    /*::  This function converts decimal degrees to radians             :*/
    /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    private Decimal deg2rad(Decimal deg) {
        Decimal dbl = Math.atan2(1,1)*4;
        return (deg*dbl/180.0);
    }

    /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    /*::  This function converts radians to decimal degrees             :*/
    /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    private Decimal rad2deg(Decimal rad) {
        Decimal dbl = Math.atan2(1,1)*4;
        return (rad*180.0/dbl);
    }
    
    public PageReference updateLongLat(){
        return null;
    }
    
}