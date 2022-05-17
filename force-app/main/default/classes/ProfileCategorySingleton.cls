public with sharing class ProfileCategorySingleton {

    private static ProfileCategorySingleton instance = null;
    public String profileCategory {get; private set;}

    private ProfileCategorySingleton() {
        getProfileCategory();
    }

    private void getProfileCategory(){
        String userProfileName = [Select Name from Profile where Id =:UserInfo.getProfileId()].Name;
        for(Profile_Grouping__mdt pg :Profile_Grouping__mdt.getAll().values()){
            if(pg.MasterLabel == userProfileName){
                this.profileCategory = pg.Category__c;
                break;
            }
        }
    }

    public static ProfileCategorySingleton getInstance(){
        if(instance == null) instance = new ProfileCategorySingleton();
        return instance;
    }
}
