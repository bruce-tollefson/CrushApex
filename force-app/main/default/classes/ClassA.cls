public with sharing class ClassA {
    public static String getProfileCategory() {
        return ProfileCategorySingleton.getInstance().profileCategory;
    }

}
