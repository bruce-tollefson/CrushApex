public with sharing class ClassB {
    public static String getProfileCategory() {
        return ProfileCategorySingleton.getInstance().profileCategory;
    }

}
