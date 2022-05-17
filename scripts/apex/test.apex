Set<Account> accountList = new Set<Account>{new Account(name='Test')};
Database.insert(accountList, false);

Set<String> strSet = new Set<String>();

strSet.add('Best Class');
strSet.add('Ever');
strSet.add('Ever');
strSet.add('EVER');
system.debug(strSet);

Integer x = 6, y = 8, z = '2'; 

Date today = date.today();
System.debug(today);
DateTime nowDT = DateTime.now();
system.debug(nowDT);
system.debug(nowDT.time());
system.debug(nowDT.date());
String formattedDT = nowDT.format();
system.debug(formattedDT);


Account acct = new Account(name='I am having so much fun!'); 
Object nameObj = acct.Name; 
system.debug(nameObj);


List<Account> acct = [Select Id from Account where CreatedDate > LAST_N_DAYS:14];

system.debug([Select Id from Account where CreatedDate < LAST_N_DAYS:14].size());

List<sObject> sObjectList =  [FIND 'map*' IN ALL FIELDS RETURNING Account (Id, Name)];

sObject test = new Account();

integer a = 1;
do {
    system.debug(a);
    a*=2;
}while( a < 20 );


Account acct = new Account();
try{
insert acct;
}catch(DmlException e){
    system.debug('Got Here');
}


for(sObject vdt : [Select Id from Account]){

    system.debug(vdt);

}